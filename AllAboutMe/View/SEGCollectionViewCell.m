//
//  SEGCollectionViewCell.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/27/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGCollectionViewCell.h"

@interface SEGCollectionViewCell ()

@property UILabel *titleLabel;
@property UIImageView *imageView;

@end

@implementation SEGCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, frame.size.width, 30)];
        _titleLabel.textColor = SEG_TEXT_COLOR;
        _titleLabel.backgroundColor = UIColor.clearColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, 80)];
        _imageView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
