//
//  SEGSongCell.h
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/30/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEGSongCell : UITableViewCell

@property (nonatomic) UIImageView *coverArt;

- (void)setArtist:(NSString *)artist;
- (void)setTitle:(NSString *)title;
- (void)setAlbum:(NSString *)album;

@end
