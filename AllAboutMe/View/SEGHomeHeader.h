//
//  SEGHomeHeader.h
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/28/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEGHomeHeader : UICollectionReusableView

@property (nonatomic, copy) NSAttributedString *attributedString;
@property (nonatomic) UIImageView *image;
@property (nonatomic, readwrite, assign) CFIndex mode;

@end
