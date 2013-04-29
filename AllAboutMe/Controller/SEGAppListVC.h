//
//  SEGAppListVC.h
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/29/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SEGAppListVCModeOwn,
    SEGAppListVCModeTopTen
} SEGAppListVCMode;

@interface SEGAppListVC : UITableViewController

@property SEGAppListVCMode mode;

- (id)initWithMode:(SEGAppListVCMode)mode;

@end
