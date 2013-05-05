//
//  SEGCollectionViewCell.h
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/27/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEGCollectionViewCell : UICollectionViewCell

- (void)setImage:(UIImage *)image;
- (void)setTitle:(NSString *)title;

- (void)setServiceName:(NSString *)name socialFont:(BOOL)social;
- (void)setServiceName:(NSString *)name withFont:(UIFont *)font;

@end
