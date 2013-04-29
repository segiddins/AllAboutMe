//
//  SEGHomeVC.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/27/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGHomeVC.h"
#import "SEGCollectionViewCell.h"
#import "SEGADNViewController.h"
#import "SEGUser.h"
#import "JHWebBrowser.h"
#import "SEGBlogListVC.h"
#import "SEGYoutubeCollectionVC.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SEGHomeHeader.h"
#import "SEGBookmarksVC.h"

@interface SEGHomeVC () <UICollectionViewDelegateFlowLayout>

@property SEGHomeHeader *headerView;

@end

@implementation SEGHomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
        [self.collectionView registerClass:[SEGCollectionViewCell class] forCellWithReuseIdentifier:@"Home Cell"];
        [self.collectionView registerClass:[SEGHomeHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Home Header"];
        [(UICollectionViewFlowLayout *)layout setSectionInset:UIEdgeInsetsMake(15, 20, 10, 20)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = UIColor.clearColor;
	// Do any additional setup after loading the view.
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setHeaderReferenceSize:CGSizeMake(self.collectionView.frame.size.width, 275)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = SEGUser.currentUser.name;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self openWebsite];
            break;
            
        case 1:
            [self.navigationController pushViewController:[SEGADNViewController new] animated:YES];
            break;
            
        case 3:
            [self openBlog];
            break;
            
        case 5:
            [self.navigationController pushViewController:[SEGBookmarksVC new] animated:YES];
            break;
            
        case 6:
            [self.navigationController pushViewController:[[SEGYoutubeCollectionVC alloc] init] animated:YES];
            break;
            
        default:
            break;
    }
}

- (void)openWebsite {
    JHWebBrowser *browser = [[JHWebBrowser alloc] init];
    browser.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", SEGUser.currentUser.websiteURL]];
    browser.showTitleBar = NO;
    browser.canDoTextOnly = YES;
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)openBlog {
    SEGBlogListVC *blog = [SEGBlogListVC new];
    [self.navigationController pushViewController:blog animated:YES];
}

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SEGHomeHeader *suppView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Home Header" forIndexPath:indexPath];
    suppView.backgroundColor = [UIColor colorWithRed:0.235 green:0.275 blue:0.275 alpha:0.398438];
    
    UIImageView *profPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
    [profPic setImageWithURL:[NSURL URLWithString:[[SEGUser currentUser] profilePicURL]]];
    suppView.image = profPic;
    
    NSAttributedString *desc = [[NSAttributedString alloc] initWithString:[[SEGUser currentUser] profileDesc] attributes:@{NSForegroundColorAttributeName:SEG_TEXT_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:15.0],}];
    suppView.attributedString = desc;

    suppView.mode = 4;
    
    return suppView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SEGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Home Cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            [self configureWebsiteCell:cell];
            break;
            
        case 1:
            [self configureADNCell:cell];
            break;
            
        case 2:
            [self configureTop10sCell:cell];
            break;
            
        case 3:
            [self configureBlogCell:cell];
            break;
            
        case 4:
            [self configureAppsCell:cell];
            break;
            
        case 5:
            [self configureRecentReadsCell:cell];
            break;
            
        case 6:
            [self configureYoutubeCell:cell];
            break;
            
        default:
            cell.title = [NSString stringWithFormat:@"%d", indexPath.row];
            cell.image = nil;
            break;
    }
    return cell;
}

#pragma mark Cell Config

- (void)configureWebsiteCell:(SEGCollectionViewCell *)cell {
    cell.title = @"Website";
    cell.image = [UIImage imageNamed:@"website"];
}

- (void)configureADNCell:(SEGCollectionViewCell *)cell {
    cell.title = @"App.net";
    cell.image = [UIImage imageNamed:@"adn"];
}

- (void)configureTop10sCell:(SEGCollectionViewCell *)cell {
    cell.title = @"10s";
    cell.image= [UIImage imageNamed:@"10s"];
}

- (void)configureBlogCell:(SEGCollectionViewCell *)cell {
    cell.title = @"Blog";
    cell.image = [UIImage imageNamed:@"blog"];
}

- (void)configureRecentReadsCell:(SEGCollectionViewCell *)cell {
    cell.title = @"Recent Reads";
    cell.image = [UIImage imageNamed:@"bookmark"];
}

- (void)configureAppsCell:(SEGCollectionViewCell *)cell {
    cell.title = @"Apps";
    cell.image = [UIImage imageNamed:@"apps"];
}

- (void)configureYoutubeCell:(SEGCollectionViewCell *)cell {
    cell.title = @"Youtube Vids";
    cell.image = [UIImage imageNamed:@"youtube"];
}

@end
