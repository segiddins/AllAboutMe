//
//  SEGUser.h
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/25/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEGUser : NSObject

@property NSString *username;
@property NSNumber *userID;
@property NSString *name;
@property NSString *youtubeUsername;
@property NSString *adnUsername;
@property NSString *websiteURL;
@property NSString *blogURL;
@property NSString *pinboardUsername;
@property NSString *profileDesc;
@property NSString *profilePicURL;

@property NSArray  *RSSItems;
@property NSArray  *ADNPosts;
@property NSArray  *youtubeVideos;
@property NSArray  *bookmarks;
@property NSArray  *apps;
@property NSArray  *topApps;
@property NSArray  *songs;

+ (instancetype)currentUser;
+ (void)userWithUsername:(NSString *)username callback:(void (^)(SEGUser *user))block;

- (void)loadBlogPostsWithCompletion:(void (^)(NSArray* feedItems, NSError* error))block;
- (void)loadADNPostsWithCompletion:(void (^)(NSArray* posts, NSError* error))block;
- (void)loadYoutubeVideosWithCompletion:(void (^)(NSArray* videos, NSError* error))block;
- (void)loadBookmarksWithCompletion:(void (^)(NSArray* bookmarks, NSError* error))block;
- (void)loadSongsWithCompletion:(void (^)(NSArray* songs, NSError* error))block;
- (void)loadAppsWithCompletion:(void (^)(NSArray* apps, NSError* error))block;
- (void)loadTopAppsWithCompletion:(void (^)(NSArray* apps, NSError* error))block;


@end
