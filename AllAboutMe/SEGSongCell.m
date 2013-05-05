//
//  SEGSongCell.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/30/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGSongCell.h"

@interface SEGSongCell ()

@property UILabel *artistLabel;
@property UILabel *titleLable;
@property UILabel *albumLabel;

@end

@implementation SEGSongCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, self.frame.size.width - 115, 30)];
        _albumLabel.textColor = SEG_TEXT_COLOR;
        _albumLabel.backgroundColor = [UIColor clearColor];
        
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, self.frame.size.width - 115, 20)];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.font = [UIFont boldSystemFontOfSize:19];
        
        _artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, self.frame.size.width - 115, 30)];
        _artistLabel.textColor = SEG_TEXT_COLOR;
        _artistLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_albumLabel];
        [self.contentView addSubview:_titleLable];
        [self.contentView addSubview:_artistLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title {
    self.titleLable.text = title;
    [_titleLable setAdjustsFontSizeToFitWidth:YES];
    [_titleLable setAdjustsLetterSpacingToFitWidth:YES];
    [_titleLable setMinimumScaleFactor:.6];
}

- (void)setAlbum:(NSString *)album {
    self.albumLabel.text = album;
    [self.albumLabel sizeToFit];
}

- (void)setArtist:(NSString *)artist {
    self.artistLabel.text = artist;
    [self.artistLabel sizeToFit];
}

- (void)setCoverArt:(UIImageView *)coverArt {
    [_coverArt removeFromSuperview];
    _coverArt = coverArt;
    _coverArt.frame = CGRectMake(5, 5, 100, 100);
    [self.contentView addSubview:_coverArt];
}

@end
