//
//  SEGAppDelegate.h
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/25/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface SEGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property MSClient *client;

@end

/** This category enhances NSMutableArray by providing methods to randomly
 * shuffle the elements using the Fisher-Yates algorithm.
 */
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end

@interface NSArray (ShuffledArray)

- (NSArray *)shuffledArray;

@end
