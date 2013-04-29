//
//  SEGUser.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/25/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGUser.h"
#import <HCYoutubeParser/HCYoutubeParser.h>
#import <BlockRSSParser/RSSParser.h>
#import <ADNKit/ADNKit.h>
#import <RestKit/RestKit.h>
#import <iTunesSearch/ItunesSearch.h>
#import "SEGSong.h"
#import "SEGApp.h"

@interface RSSItem (YoutubeVideos)

- (NSString *)seg_videoIDFromLink;

@end

NSString *SEGCurrentUserNSUDKey = @"SEGCurrentUserNSUDKey";

@implementation SEGUser

static SEGUser *_currentUser;

+ (instancetype)currentUser {
//    if (!_currentUser) {
////        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:SEGCurrentUserNSUDKey];
////        if (username) {
//            [self userWithUsername:username callback:^(SEGUser *user) {
//
//            }];
////        }
//    }
    return _currentUser;
}

+ (void)userWithUsername:(NSString *)username callback:(void (^)(SEGUser *user))block {
    MSClient *client = [(SEGAppDelegate *)UIApplication.sharedApplication.delegate client];
    MSTable *usersTable = [client tableWithName:@"users"];
    [usersTable readWithQueryString:[NSString stringWithFormat:@"username=%@", username] completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if (error) {
            NSLog(@">>> ERROR: %@", error.debugDescription);
            return;
        }
     if (items.count > 1 ) {
         NSLog(@">>> Too many matched users");
         return;
     } else if (items.count < 1) {
         NSLog(@">>> No matching user");
         return;
     }
     _currentUser = [[self alloc] initWithDictionary:items[0]];
        block(_currentUser);
        [[NSUserDefaults standardUserDefaults] setValue:username forKey:SEGCurrentUserNSUDKey];
        [_currentUser loadSongsWithCompletion:^(NSArray *videos, NSError *error) {}];
        [_currentUser loadAppsWithCompletion:^(NSArray *apps, NSError *error) {}];
    }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.username = dictionary[@"username"];
        self.userID = dictionary[@"id"];
        self.name = dictionary[@"name"];
        self.youtubeUsername = dictionary[@"youtube"];
        self.adnUsername = dictionary[@"adn"];
        self.websiteURL = dictionary[@"website"];
        self.blogURL = dictionary[@"blog"];
        self.pinboardUsername = dictionary[@"pinboard"];
        self.profileDesc = dictionary[@"description"];
        self.profilePicURL = dictionary[@"profilePicURL"];
    }

    return self;
}

- (void)loadBlogPostsWithCompletion:(void (^)(NSArray* feedItems, NSError* error))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/feed.xml",self.blogURL]]];
        [RSSParser parseRSSFeedForRequest:request
                                  success:^(NSArray *feedItems) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                      self.RSSItems = feedItems;
                                      block(feedItems, nil);
                                      });
                                  }
                                  failure:^(NSError *error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                      NSLog(@">>> ERROR: %@", error);
                                      block(nil, error);
                                      });
                                  }];
    });
}

- (void)loadADNPostsWithCompletion:(void (^)(NSArray* posts, NSError* error))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ANKClient *client = [ANKClient sharedClient];
        [client fetchPostsCreatedByUserWithID:[NSString stringWithFormat:@"@%@", self.adnUsername]
                                   completion:^(id responseObject, ANKAPIResponseMeta *meta, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (error) {
                                               NSLog(@">>> ERROR: %@", error);
                                               block(nil, error);
                                               return;
                                           }
                                           self.ADNPosts = responseObject;
                                           block(responseObject, nil);
                                       });
                                   }];
    });
}

- (void)loadYoutubeVideosWithCompletion:(void (^)(NSArray* videos, NSError* error))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *feed = [NSURL URLWithString:[NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/users/%@/uploads?orderby=published", self.youtubeUsername]];

        [RSSParser parseRSSFeedForRequest:[NSURLRequest requestWithURL:feed]
                                  success:^(NSArray *feedItems) {
                                      NSMutableArray *array = [feedItems mutableCopy];
                                      __block int replaced = 0;
                                      for (RSSItem *vid in feedItems) {
                                          NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", [vid.link lastPathComponent]]];
                                          [HCYoutubeParser detailsForYouTubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
                                              replaced++;
                                              if (error || videoDictionary == nil) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      NSLog(@">>> ERROR: %@",error);
                                                      block(nil, error);
                                                  });
                                                  return;
                                              }
                                              [array replaceObjectAtIndex:[array indexOfObject:vid] withObject:videoDictionary];
                                              if (replaced == feedItems.count) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      self.youtubeVideos = [NSArray arrayWithArray:array];
                                                      block(self.youtubeVideos, nil);
                                                  });
                                              }
                                          }];
                                      }
                                  } failure:^(NSError *error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                      NSLog(@">>> ERROR: %@",error);
                                      block(nil, error);
                                      });
                                  }];
    });
}

- (void)loadBookmarksWithCompletion:(void (^)(NSArray* bookmarks, NSError* error))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://feeds.pinboard.in/rss/u:%@/", self.pinboardUsername]];

        [RSSParser parseRSSFeedForRequest:[NSURLRequest requestWithURL:url]
                                  success:^(NSArray *feedItems) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          self.bookmarks = feedItems;
                                          block(feedItems, nil);
                                      });
                                  } failure:^(NSError *error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          NSLog(@">>> ERROR: %@",error);
                                          block(nil, error);
                                      });
                                  }];
    });
}

- (void)loadSongsWithCompletion:(void (^)(NSArray* songs, NSError* error))block {
  MSClient *client = [(SEGAppDelegate *)UIApplication.sharedApplication.delegate client];
  MSTable *songsTable = [client tableWithName:@"songs"];
  [songsTable readWithQueryString:[NSString stringWithFormat:@"userid=%@", self.userID] completion:^(NSArray *songs, NSInteger totalCount, NSError *error) {
      if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          NSLog(@">>> ERROR: %@", error.debugDescription);
          block(nil, error);
        });
          return;
      }
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          NSMutableArray *segSongs = [NSMutableArray array];
          for (NSDictionary *dict in songs) {
              SEGSong *song = [[SEGSong alloc] initWithDictionary:dict];
              [song loadTrackInfo];
              [segSongs addObject:song];
          }
          
          while (![SEGSong allLoaded]) {
              
          }
          self.songs = [NSArray arrayWithArray:segSongs];
          dispatch_async(dispatch_get_main_queue(), ^{
              block(self.songs, nil);
          });
      });
  }];
}

- (void)loadAppsWithCompletion:(void (^)(NSArray* apps, NSError* error))block {
    MSClient *client = [(SEGAppDelegate *)UIApplication.sharedApplication.delegate client];
    MSTable *appsTable = [client tableWithName:@"apps"];
    [appsTable readWithQueryString:[NSString stringWithFormat:@"userid=%@&isown=1", self.userID] completion:^(NSArray *apps, NSInteger totalCount, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@">>> ERROR: %@", error.debugDescription);
                block(nil, error);
            });
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *segApps = [NSMutableArray array];
            for (NSDictionary *dict in apps) {
                SEGApp *app = [[SEGApp alloc] initWithDictionary:dict];
                [app loadAppInfo];
                [segApps addObject:app];
            }
            
            while (![SEGApp allLoaded]) {
                
            }
            self.apps = [NSArray arrayWithArray:segApps];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(self.apps, nil);
            });
        });
    }];
}

@end

@implementation RSSItem (YoutubeVideos)

- (NSString *)seg_videoIDFromLink {
    return [self.link lastPathComponent];
}

@end