//
//  SEGSong.h
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/29/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEGSong : NSObject

@property NSString *title;
@property NSString *artist;
@property NSString *album;
@property NSURL    *artworkURL;
@property NSURL    *previewURL;
@property NSURL    *trackURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)loadTrackInfo;
+ (BOOL)allLoaded;

@end
