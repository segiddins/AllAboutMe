//
//  SEGApp.h
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/29/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEGApp : NSObject

@property NSString *title;
@property NSString *itmsID;
@property NSURL    *artworkURL;
@property NSURL    *link;
@property NSString *appDescription;
@property NSString *developer;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)loadAppInfo;
+ (BOOL)allLoaded;


@end
