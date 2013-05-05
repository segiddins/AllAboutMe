//
//  SEGAppListVC.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/29/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGAppListVC.h"
#import "SEGAppCell.h"
#import "SEGUser.h"
#import "SEGApp.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface SEGAppListVC () <HHPanningTableViewCellDelegate>

@property NSArray *apps;

@end

@implementation SEGAppListVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMode:(SEGAppListVCMode)mode {
    if (self = [super init]) {
        _mode = mode;
        switch (mode) {
            case SEGAppListVCModeOwn:
                self.title = [NSString stringWithFormat:@"%@'s Apps", SEGUser.currentUser.name];
                break;
            case SEGAppListVCModeTopTen:
                self.title = @"Top Ten Apps";
                break;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadApps) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.separatorColor = [UIColor colorWithRed:0.278 green:0.286 blue:0.286 alpha:1.000];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self reloadApps];
}

- (void)reloadApps {
    void(^block)(NSArray *apps, NSError *error) = ^(NSArray *apps, NSError *error) {
        self.apps = apps;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    };
    switch (self.mode) {
        case SEGAppListVCModeOwn:
            [[SEGUser currentUser] loadAppsWithCompletion:block];
            break;
            
        case SEGAppListVCModeTopTen:
            [[SEGUser currentUser] loadTopAppsWithCompletion:block];
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.apps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"App Cell";
    SEGAppCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[SEGAppCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    SEGApp *app = self.apps[indexPath.row];
    
    [cell setDescription:app.appDescription];
    UIImageView *artwork = [UIImageView new];
    [artwork setImageWithURL:app.artworkURL];
    cell.artworkView = artwork;
    cell.titleLabel.text = app.title;
    cell.devLabel.text = app.developer;
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEGApp *app = self.apps[indexPath.row];
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    [[UIApplication sharedApplication] openURL:app.link];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SEGApp *app = self.apps[indexPath.row];
    CGFloat height = 5 + 100 + 5 + 0 +5;
    CGSize descSize = [app.appDescription sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(self.view.frame.size.width - 10, 5000) lineBreakMode:NSLineBreakByWordWrapping];
    return height + descSize.height;
}

#pragma mark - PanningTableViewCell Delegate

- (BOOL)panningTableViewCell:(HHPanningTableViewCell *)cell shouldReceivePanningTouch:(UITouch *)touch {
    return NO;
}


@end
