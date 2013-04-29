//
//  SEGBlogListVC.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/27/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGBlogListVC.h"
#import "SEGUser.h"
#import <BlockRSSParser/RSSItem.h>
#import "DetailViewController.h"

@interface SEGBlogListVC ()

@property NSArray *posts;
@property DetailViewController *detailViewController;

@end

@implementation SEGBlogListVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
//        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BlogPost"];
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
    [self.refreshControl addTarget:self action:@selector(reloadPosts) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.separatorColor = [UIColor colorWithRed:0.278 green:0.286 blue:0.286 alpha:1.000];
    self.view.backgroundColor = UIColor.clearColor;
    self.title = [NSString stringWithFormat:@"%@'s Posts", SEGUser.currentUser.name];
    
    [self reloadPosts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [NSString stringWithFormat:@"%@'s Posts", SEGUser.currentUser.name];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = nil;
}

- (void)reloadPosts {
    [[SEGUser currentUser] loadBlogPostsWithCompletion:^(NSArray *posts, NSError *error) {
        self.posts = [[SEGUser currentUser] RSSItems];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BlogPost";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    RSSItem *post = self.posts[indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = post.title;
    cell.textLabel.textColor = UIColor.whiteColor;
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    }
    cell.detailTextLabel.text = [dateFormatter stringFromDate:post.pubDate];
    cell.detailTextLabel.textColor = SEG_TEXT_COLOR;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailViewController = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
    self.detailViewController.appData = self.posts;
    self.detailViewController.startIndex = indexPath.row;
    self.detailViewController.view.frame = self.view.bounds;
    [self.detailViewController willAppearIn:self.navigationController];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
