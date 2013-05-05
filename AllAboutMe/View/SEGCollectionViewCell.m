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
@property UILabel *serviceLabel;

@end

@implementation SEGCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, frame.size.width, 25)];
        _titleLabel.textColor = SEG_TEXT_COLOR;
        _titleLabel.backgroundColor = UIColor.clearColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, 90)];
        _imageView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:_titleLabel];
        _serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, 90)];
        _serviceLabel.textColor = [UIColor colorWithWhite:0.902 alpha:1.000];
        _serviceLabel.backgroundColor = UIColor.clearColor;
        _serviceLabel.textAlignment = NSTextAlignmentCenter;
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
    [self.serviceLabel removeFromSuperview];
    [self.contentView addSubview:self.imageView];
}

- (void)setServiceName:(NSString *)name socialFont:(BOOL)social {
    [self setServiceName:name withFont:[UIFont fontWithName:[NSString stringWithFormat:@"SS%@", social ? @"SocialRegular" : @"Standard"] size:70]];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setServiceName:(NSString *)name withFont:(UIFont *)font {
    self.serviceLabel.text = name;
    self.serviceLabel.font = font;
    [self.imageView removeFromSuperview];
    [self.contentView addSubview:_serviceLabel];
}

@end
