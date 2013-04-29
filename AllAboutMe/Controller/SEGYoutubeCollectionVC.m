//
//  SEGYoutubeCollectionVC.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/27/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGYoutubeCollectionVC.h"
#import "SEGYoutubeCell.h"
#import "SEGUser.h"
#import <HCYoutubeParser/HCYoutubeParser.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MediaPlayer/MediaPlayer.h>

@interface NSString (Date)
+ (NSDate*)stringDateFromString:(NSString*)string;
+ (NSString*)stringDateFromDate:(NSDate*)date;
@end

@interface SEGYoutubeCollectionVC () <UICollectionViewDelegateFlowLayout>

@property NSArray *videos;

@end

@implementation SEGYoutubeCollectionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    if (self = [super initWithCollectionViewLayout:layout]) {
        layout.itemSize = CGSizeMake(self.collectionView.frame.size.width, 300);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = UIColor.clearColor;
    [self.collectionView registerClass:[SEGYoutubeCell class] forCellWithReuseIdentifier:@"Video Cell"];
	// Do any additional setup after loading the view.
    [self reloadPosts];
    self.title = [NSString stringWithFormat:@"%@ on Youtube", [[SEGUser currentUser] youtubeUsername]];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)reloadPosts {
    [[SEGUser currentUser] loadYoutubeVideosWithCompletion:^(NSArray *videos, NSError *error) {
        self.videos = videos;
        [self.collectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *vid = self.videos[indexPath.row];
    NSDictionary *h264 = [HCYoutubeParser h264videosWithYoutubeID: [[[[vid objectForKey:@"entry"] objectForKey:@"id"] objectForKey:@"$t"] lastPathComponent]];
    NSString *urlString = h264[@"hd1080"] ?: h264[@"hd720"] ?: h264[@"medium"] ?: h264[@"small"] ?: nil;
    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:urlString]];
    [mp.moviePlayer prepareToPlay];
    [self presentMoviePlayerViewControllerAnimated:mp];
    [mp.moviePlayer setFullscreen:YES animated:YES];
    [mp.moviePlayer setAllowsAirPlay:YES];
    [mp.moviePlayer setShouldAutoplay:YES];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(vidDone:) name:MPMoviePlayerWillExitFullscreenNotification object:mp.moviePlayer];
}

- (void)vidDone:(NSNotification *)notification {
    [self dismissMoviePlayerViewControllerAnimated];
    [NSNotificationCenter.defaultCenter removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SEGYoutubeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Video Cell" forIndexPath:indexPath];
    
    NSDictionary *video = self.videos[indexPath.row];
    
    cell.title = [[[video objectForKey:@"entry"] objectForKey:@"title"] objectForKey:@"$t"];
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    }
    cell.date = [dateFormatter stringFromDate: [NSString stringDateFromString:[[[video objectForKey:@"entry"] objectForKey:@"published"] objectForKey:@"$t"]]];
    
    UIImageView *thumb = [UIImageView new];
    NSURL *url = [NSURL URLWithString:[[[[[video objectForKey:@"entry"]  objectForKey:@"media$group" ] objectForKey:@"media$thumbnail"] objectAtIndex:0] objectForKey:@"url"]];
    [thumb setImageWithURL:url];
    
    cell.thumb = thumb;
    cell.desc = [[[video objectForKey:@"entry"] objectForKey:@"content"] objectForKey:@"$t"];
    NSLog(@"cell desc: %@", cell.desc);
    
    return cell;
}

#pragma mark - FlowLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.frame.size.width;
    NSDictionary *video = self.videos[indexPath.row];
    NSString *desc = [[[video objectForKey:@"entry"] objectForKey:@"content"] objectForKey:@"$t"];
    CGFloat descHeight = [desc sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
    return CGSizeMake(width, descHeight + 105);
}

@end



@implementation NSString (Date)

// NSString+Date.m
+ (NSDateFormatter*)stringDateFormatter
{
    static NSDateFormatter* formatter = nil;
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.000Z'"];
    }
    return formatter;
}

+ (NSDate*)stringDateFromString:(NSString*)string
{
    return [[NSString stringDateFormatter] dateFromString:string];
}

+ (NSString*)stringDateFromDate:(NSDate*)date
{
    return [[NSString stringDateFormatter] stringFromDate:date];
}

@end
