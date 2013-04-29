//
//  SEGADNViewController.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/26/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGADNViewController.h"

#import "SEGUser.h"
#import "SEGADNCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <ADNKit/ADNKit.h>

@interface SEGADNViewController ()

@end

@implementation SEGADNViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.tableView registerClass:SEGADNCell.class forCellReuseIdentifier:@"SEGADNCell"];
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
    self.title = [NSString stringWithFormat:@"@%@ on ", SEGUser.currentUser.adnUsername];
    
    [self reloadPosts];
}

- (void)reloadPosts {
    [[SEGUser currentUser] loadADNPostsWithCompletion:^(NSArray *posts, NSError *error) {
        self.posts = [[SEGUser currentUser] ADNPosts];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:@"SSSocialRegular" size:20.0]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldSystemFontOfSize:19.0]}];
    [super viewWillDisappear:animated];
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
    static NSString *CellIdentifier = @"SEGADNCell";
    SEGADNCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    ANKPost *post = self.posts[indexPath.row];
    
    cell.avatarImageView = [[UIImageView alloc] init];
    [cell.avatarImageView setImageWithURL:post.user.avatarImage.URL];
    
    cell.textLabel.text = post.text;
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    cell.dateLabel.text = [dateFormatter stringFromDate:post.createdAt];
    
//    cell.userInteractionEnabled = NO;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[[self.posts[indexPath.row] text]] applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ANKPost *post = self.posts[indexPath.row];
    CGSize size = [post.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(self.view.frame.size.width - 10, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    return 65 + size.height;
}

@end
