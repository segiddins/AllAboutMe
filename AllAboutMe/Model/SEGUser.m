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
    [SVProgressHUD showWithStatus:[NSString stringWithFormat: @"Loading %@", username] maskType:SVProgressHUDMaskTypeBlack];
    MSClient *client = [(SEGAppDelegate *)UIApplication.sharedApplication.delegate client];
    MSTable *usersTable = [client tableWithName:@"users"];
    [usersTable readWithQueryString:[[NSString stringWithFormat:@"$filter=username eq '%@'", username] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            NSLog(@">>> ERROR: %@", error.debugDescription);
            return;
        }
         if (items.count > 1 ) {
             [SVProgressHUD showErrorWithStatus:@"Server error :("];
             NSLog(@">>> Too many matched users");
             return;
         } else if (items.count < 1) {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat: @"No user named %@ ", username]];
             NSLog(@">>> No matching user");
             return;
         }
         _currentUser = [[self alloc] initWithDictionary:items[0]];
            [SVProgressHUD dismiss];
            block(_currentUser);
            [[NSUserDefaults standardUserDefaults] setValue:username forKey:SEGCurrentUserNSUDKey];
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
    [SVProgressHUD showWithStatus:@"Loading Blog Posts..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/feed.xml",self.blogURL]]];
        [RSSParser parseRSSFeedForRequest:request
                                  success:^(NSArray *feedItems) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                      self.RSSItems = feedItems;
                                          [SVProgressHUD dismiss];
                                      block(feedItems, nil);
                                      });
                                  }
                                  failure:^(NSError *error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                      NSLog(@">>> ERROR: %@", error);
                                      block(nil, error);
                                      });
                                  }];
    });
}

- (void)loadADNPostsWithCompletion:(void (^)(NSArray* posts, NSError* error))block {
    [SVProgressHUD showWithStatus:@"Loading ADN Posts..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ANKClient *client = [ANKClient sharedClient];
        [client fetchPostsCreatedByUserWithID:[NSString stringWithFormat:@"@%@", self.adnUsername]
                                   completion:^(id responseObject, ANKAPIResponseMeta *meta, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (error) {
                                               [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                               NSLog(@">>> ERROR: %@", error);
                                               block(nil, error);
                                               return;
                                           }
                                           self.ADNPosts = responseObject;
                                           [SVProgressHUD dismiss];
                                           block(responseObject, nil);
                                       });
                                   }];
    });
}

- (void)loadYoutubeVideosWithCompletion:(void (^)(NSArray* videos, NSError* error))block {
    [SVProgressHUD showWithStatus:@"Loading Youtube Videos..."];
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
                                                      [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                      NSLog(@">>> ERROR: %@",error);
                                                      block(nil, error);
                                                  });
                                                  return;
                                              }
                                              [array replaceObjectAtIndex:[array indexOfObject:vid] withObject:videoDictionary];
                                              if (replaced == feedItems.count) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      self.youtubeVideos = [NSArray arrayWithArray:array];
                                                      [SVProgressHUD dismiss];
                                                      block(self.youtubeVideos, nil);
                                                  });
                                              }
                                          }];
                                      }
                                  } failure:^(NSError *error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                      NSLog(@">>> ERROR: %@",error);
                                      block(nil, error);
                                      });
                                  }];
    });
}

- (void)loadBookmarksWithCompletion:(void (^)(NSArray* bookmarks, NSError* error))block {
    [SVProgressHUD showWithStatus:@"Loading Recent Reads..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://feeds.pinboard.in/rss/u:%@/", self.pinboardUsername]];

        [RSSParser parseRSSFeedForRequest:[NSURLRequest requestWithURL:url]
                                  success:^(NSArray *feedItems) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          self.bookmarks = feedItems;
                                          [SVProgressHUD dismiss];
                                          block(feedItems, nil);
                                      });
                                  } failure:^(NSError *error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                          NSLog(@">>> ERROR: %@",error);
                                          block(nil, error);
                                      });
                                  }];
    });
}

- (void)loadSongsWithCompletion:(void (^)(NSArray* songs, NSError* error))block {
  MSClient *client = [(SEGAppDelegate *)UIApplication.sharedApplication.delegate client];
  MSTable *songsTable = [client tableWithName:@"songs"];
    [SVProgressHUD showWithStatus:@"Loading Top Ten Songs..."];
  [songsTable readWithQueryString:[[NSString stringWithFormat:@"$filter=userid eq %@", self.userID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] completion:^(NSArray *songs, NSInteger totalCount, NSError *error) {
      if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
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
          [segSongs shuffle];
          self.songs = [NSArray arrayWithArray:segSongs];
          dispatch_async(dispatch_get_main_queue(), ^{
              [SVProgressHUD dismiss];
              block(self.songs, nil);
          });
      });
  }];
}

- (void)loadAppsWithCompletion:(void (^)(NSArray* apps, NSError* error))block {
    [SVProgressHUD showWithStatus:@"Loading My Apps..."];
    MSClient *client = [(SEGAppDelegate *)UIApplication.sharedApplication.delegate client];
    MSTable *appsTable = [client tableWithName:@"apps"];
    [appsTable readWithQueryString:[[NSString stringWithFormat:@"$filter=userid eq %@ and isown eq 1", self.userID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] completion:^(NSArray *apps, NSInteger totalCount, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
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
            [segApps shuffle];
            self.apps = [NSArray arrayWithArray:segApps];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                block(self.apps, nil);
            });
        });
    }];
}

- (void)loadTopAppsWithCompletion:(void (^)(NSArray* apps, NSError* error))block {
    MSClient *client = [(SEGAppDelegate *)UIApplication.sharedApplication.delegate client];
    MSTable *appsTable = [client tableWithName:@"apps"];
    [SVProgressHUD showWithStatus:@"Loading Top Ten Apps"];
    [appsTable readWithQueryString:[[NSString stringWithFormat:@"$filter=userid eq %@ and isown eq 0", self.userID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] completion:^(NSArray *apps, NSInteger totalCount, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
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
            [segApps shuffle];
            self.topApps = [NSArray arrayWithArray:segApps];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                block(self.topApps, nil);
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