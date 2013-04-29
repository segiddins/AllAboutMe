//
//  SEGADNCell.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/26/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGADNCell.h"

@interface SEGADNCell ()

@end

@implementation SEGADNCell

- (id)init {
    if (self = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SEGADNCell"]) {
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _dateLabel = [[UILabel alloc] init];
        CGRect frame = CGRectMake(60, 5, self.frame.size.width - 65, 50);
        _dateLabel.frame = frame;
        _dateLabel.backgroundColor = UIColor.clearColor;
        _dateLabel.textColor = SEG_TEXT_COLOR;
        [self addSubview:_dateLabel];
        
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.font = [UIFont systemFontOfSize:17];
        self.textLabel.textColor = SEG_TEXT_COLOR;
        
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(5, 60, self.frame.size.width - 10, self.frame.size.height - 65);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAvatarImageView:(UIImageView *)avatarImageView {
    _avatarImageView = avatarImageView;
    _avatarImageView.frame = CGRectMake(5, 5, 50, 50);
    [self addSubview:_avatarImageView];
}

@end
