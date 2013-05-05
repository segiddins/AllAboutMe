//
//  SEGSongsVC.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/30/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGSongsVC.h"
#import "SEGUser.h"
#import "SEGSong.h"
#import "SEGSongCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AVFoundation/AVFoundation.h>

@interface SEGSongsVC () 

@property NSArray *songs;
@property AVPlayer *audioPlayer;

@end

@implementation SEGSongsVC

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
        [self.tableView registerClass:[SEGSongCell class] forCellReuseIdentifier:@"Song Cell"];
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
    [self.refreshControl addTarget:self action:@selector(reloadSongs) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.separatorColor = [UIColor colorWithRed:0.278 green:0.286 blue:0.286 alpha:1.000];
    self.view.backgroundColor = UIColor.clearColor;
    self.title = [NSString stringWithFormat:@"Top Ten Songs"];
    
    [self reloadSongs];
}

- (void)reloadSongs {
    [[SEGUser currentUser] loadSongsWithCompletion:^(NSArray *songs, NSError *error) {
        self.songs = [[SEGUser currentUser] songs];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (!self.audioPlayer.rate) {
        self.audioPlayer = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"playing? %f", self.audioPlayer.rate);
    self.audioPlayer.rate = 0.0;
    [self.audioPlayer cancelPendingPrerolls];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    self.audioPlayer.rate = 0.0;
    [self.audioPlayer cancelPendingPrerolls];
    [self.audioPlayer removeObserver:self forKeyPath:@"status"];
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
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Song Cell";
    SEGSongCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SEGSong *song = self.songs[indexPath.row];
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    cell.title = song.title;
    cell.artist = song.artist;
    cell.album = song.album;
    UIImageView *coverArt = [UIImageView new];
    [coverArt setImageWithURL:song.artworkURL];
    cell.coverArt = coverArt;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEGSong *song = self.songs[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    AVURLAsset *asset = [AVURLAsset assetWithURL:song.previewURL];
    [self.audioPlayer removeObserver:self forKeyPath:@"status"];
    if ([[asset URL] isEqual:[(AVURLAsset *)self.audioPlayer.currentItem.asset URL]]) {
        [self.audioPlayer pause];
        [self.audioPlayer cancelPendingPrerolls];
        self.audioPlayer = nil;
        cell.selected = NO;
        return;
    }
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.audioPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    [self.audioPlayer addObserver:self forKeyPath:@"status" options:0 context:NULL];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    SEGSong *song = self.songs[indexPath.row];
    [[UIApplication sharedApplication] openURL:song.trackURL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.audioPlayer && [keyPath isEqualToString:@"status"]) {
        if (self.audioPlayer.status == AVPlayerStatusReadyToPlay) {
            [self.audioPlayer play];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.audioPlayer.currentItem];
        } else if (self.audioPlayer.status == AVPlayerStatusFailed) {
            [SVProgressHUD showErrorWithStatus:self.audioPlayer.error.localizedDescription];
            [self.audioPlayer removeObserver:self forKeyPath:@"status"];
            self.audioPlayer = nil;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    //allow for state updates, UI changes
    [NSNotificationCenter.defaultCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    NSLog(@"%@", AVPlayerItemDidPlayToEndTimeNotification);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

@end
