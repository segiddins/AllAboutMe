//
//  SEGYoutubeCell.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/27/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGYoutubeCell.h"

@interface SEGYoutubeCell ()

@property UILabel *titleLabel;
@property UILabel *dateLabel;
@property UILabel *descLabel;

@end

@implementation SEGYoutubeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.588 alpha:0.250];
        
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, self.frame.size.width - 135, 25)];
        _titleLabel.contentMode = UIViewContentModeCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 100, self.frame.size.width - 10, self.frame.size.height - 105)];
        _descLabel.numberOfLines = 0;
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.textColor = SEG_TEXT_COLOR;
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 45, self.frame.size.width - 135, 25)];
        _dateLabel.contentMode = UIViewContentModeCenter;
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = SEG_TEXT_COLOR;
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_descLabel];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    _title = title;
}

- (void)setDate:(NSString *)date {
    self.dateLabel.text = date;
    _date = date;
}

- (void)setThumb:(UIImageView *)thumb {
    _thumb = thumb;
    thumb.frame = CGRectMake(5, 5, 120, 90);
    _thumb.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:thumb];
}

- (void)setDesc:(NSString *)desc {
    self.descLabel.text = desc;
    _desc = desc;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
