//
//  SEGAppCell.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/29/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGAppCell.h"

@interface SEGAppCell () 

@property UILabel *descLabel;

@end

@implementation SEGAppCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        _devLabel = [UILabel new];
        _devLabel.backgroundColor = [UIColor clearColor];
        _devLabel.textColor = [UIColor whiteColor];
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 3;
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descLabel = [[UILabel alloc] init];
        _descLabel.numberOfLines = 0;
        _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descLabel.backgroundColor = UIColor.clearColor;
        _descLabel.font = [UIFont systemFontOfSize:15.0];
        _descLabel.textColor = SEG_TEXT_COLOR;
        [self.contentView addSubview:_descLabel];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_devLabel];
    }
    return self;
}

- (void)setDescription:(NSString *)description {
    self.descLabel.text = description;
}

- (void)setArtworkView:(UIImageView *)artworkView {
    [_artworkView removeFromSuperview];
    _artworkView = artworkView;
    _artworkView.frame = CGRectMake(5, 5, 100, 100);
    _artworkView.backgroundColor = [UIColor clearColor];
    [self addSubview:_artworkView];
}

- (void)layoutSubviews {
    _artworkView.frame = CGRectMake(5, 5, 100, 100);
    _descLabel.frame = CGRectMake(5, 110, self.frame.size.width - 10, self.frame.size.height - 115);
    _titleLabel.frame = CGRectMake(110, 5, self.frame.size.width - 115, 65);
     [_titleLabel sizeToFit];
    _devLabel.frame = CGRectMake(110, 75, self.frame.size.width - 115, 30);
}

@end
