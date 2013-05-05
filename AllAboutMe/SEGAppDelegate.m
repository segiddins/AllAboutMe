//
//  SEGAppDelegate.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/25/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGAppDelegate.h"
#import "SEGUser.h"

#import "SEGFollowVC.h"
#import "SEGADNViewController.h"

extern NSString *SEGCurrentUserNSUDKey;

@implementation SEGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.client = [MSClient clientWithApplicationURLString:@"https://allaboutme.azure-mobile.net/"
                                             applicationKey:***REMOVED***];
    [SEGUser currentUser];
    UIView *backgroundView = [[UIView alloc] initWithFrame: self.window.frame];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    [self.window addSubview:backgroundView];

//    if (![NSUserDefaults.standardUserDefaults stringForKey:SEGCurrentUserNSUDKey]) {
        self.window.rootViewController = [[SEGFollowVC alloc] init];
//    } else {
//        id vc = [[SEGADNViewController alloc] init];
//        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
//    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self customizeUIAppearance];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)customizeUIAppearance {
//    for (NSString *familyName in [UIFont familyNames]) {
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"%@ - %@", familyName, fontName);
//        }
//    }
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                UITextAttributeTextColor: UIColor.whiteColor
     }];
    [UINavigationBar.appearance setTintColor: [UIColor colorWithRed:0.820 green:0.314 blue:0.314 alpha:1.000]];
}

@end

@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (uint i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = arc4random_uniform(nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end

@implementation NSArray (ShuffledArray)

- (NSArray *)shuffledArray {
    NSMutableArray * temp = [NSArray arrayWithArray:[self mutableCopy]];
    [temp shuffle];
    return [NSArray arrayWithArray:temp];
}

@end
