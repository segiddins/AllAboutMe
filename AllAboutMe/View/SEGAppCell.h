//
//  SEGAppCell.h
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/29/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "HHPanningTableViewCell.h"

@interface SEGAppCell : HHPanningTableViewCell

@property (nonatomic) UIImageView *artworkView;
@property UILabel *devLabel;
@property UILabel *titleLabel;

- (void)setDescription:(NSString *)description;

@end
