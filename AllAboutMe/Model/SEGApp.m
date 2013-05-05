//
//  SEGApp.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/29/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGApp.h"
#import <iTunesSearch/ItunesSearch.h>

@implementation SEGApp

static NSInteger _loadCount = 0;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        _itmsID = dictionary[@"itms_id"];
    }
    
    return self;
}

- (void)loadAppInfo {
    _loadCount++;
    [[ItunesSearch sharedInstance] performApiCallForMethod:@"lookup" withParams:@{@"id":self.itmsID, @"media":@"software"} andFilters:nil successHandler:^(id result) {
        NSDictionary *dict = [result count] >0 ? result[0] : nil;
        _artworkURL = [NSURL URLWithString: dict[@"artworkUrl512"] ?: dict[@"artworkUrl100"] ?: dict[@"artworkUrl60"] ?: dict[@"artworkUrl30"] ?: nil];
        _link = [NSURL URLWithString: dict[@"trackViewUrl"]];
        _appDescription = dict[@"description"];
        _developer = dict[@"artistName"];
        _title = dict[@"trackName"];
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
