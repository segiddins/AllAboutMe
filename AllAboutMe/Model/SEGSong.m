//
//  SEGSong.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/29/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGSong.h"
#import <iTunesSearch/ItunesSearch.h>

@implementation SEGSong

static NSInteger _loadCount = 0;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        _title = dictionary[@"title"];
        _album = dictionary[@"album"];
        _artist = dictionary[@"artist"];
    }
    
    return self;
}

- (void)loadTrackInfo {
    _loadCount++;
    [[ItunesSearch sharedInstance] getTrackWithName:self.title artist:self.artist album:self.album limitOrNil:@1 successHandler:^(NSArray *result) {
        NSDictionary *dict = result.count >0 ? result[0] : nil;
        _artworkURL = dict[@"artworkUrl100"] ?: dict[@"artworkUrl60"] ?: dict[@"artworkUrl30"] ?: nil;
        _previewURL = dict[@"previewUrl"];
        _trackURL = dict[@"trackViewUrl"];
        _loadCount--;
    } failureHandler:^(NSError *error) {
        _loadCount--;
        NSLog(@">>> ERROR: %@", error);
    }];
}

+ (BOOL)allLoaded {
    return _loadCount == 0;
}

@end
