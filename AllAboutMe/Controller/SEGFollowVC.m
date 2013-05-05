//
//  SEGFollowVC.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/26/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGFollowVC.h"

#import "SEGUser.h"
#import "SEGHomeVC.h"

@interface SEGFollowVC () <UITextFieldDelegate>

@property UILabel *abmLabel;
@property UITextField *followField;
@property UIButton *followButton;

@end

@implementation SEGFollowVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.clearColor;
	// Do any additional setup after loading the view.
    [self setupABMLabel];
    [self setupFollow];
    [self setupCreatedBy];
    [_followField setText:@"segiddins"];
    [_followField becomeFirstResponder];
}

- (void)login {
    self.followField.text = @"segiddins";
    [SEGUser userWithUsername:self.followField.text callback:^(SEGUser *user) {
        if (user) {
            UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
            layout.itemSize = CGSizeMake(125, 125);
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[SEGHomeVC alloc]  initWithCollectionViewLayout:layout]];

            [[[[UIApplication sharedApplication] delegate] window] setRootViewController:nav];
        }
    }];
}

- (void)setupFollow {
    _followField = [[UITextField alloc] initWithFrame:CGRectMake(10, 180, self.view.frame.size.width - 90, 42)];
    _followField.placeholder = @"AllAboutMe user to follow";
    [_followField setSpellCheckingType:UITextSpellCheckingTypeNo];
    _followField.backgroundColor = UIColor.clearColor;
    _followField.borderStyle = UITextBorderStyleRoundedRect;
    [_followField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _followField.delegate = self;
    _followField.returnKeyType = UIReturnKeyGo;
    _followField.autocorrectionType = UITextAutocorrectionTypeNo;
    _followField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _followField.textColor = SEG_TEXT_COLOR;
    
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _followButton.frame = CGRectMake(self.view.frame.size.width - 70, 180, 60, 42);
    [_followButton setTitle:@"👤" forState:UIControlStateNormal];
    _followButton.titleLabel.font = [UIFont fontWithName:@"SSStandard" size:30.0];
    _followButton.backgroundColor = UIColor.clearColor;
    [_followButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    _followButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.view addSubview:_followField];
    [self.view addSubview:_followButton];
}

- (void)loginSEG {
    self.followField.text = @"segiddins";
    self.followField.placeholder = nil;
    [self login];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self login];
    return YES;
}

- (void)setupABMLabel {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    _abmLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, width, 170)];
    _abmLabel.text = @"AllAbout Me";
    _abmLabel.textAlignment = NSTextAlignmentCenter;
    _abmLabel.font = [UIFont boldSystemFontOfSize:65];
    _abmLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _abmLabel.numberOfLines = 2;
    _abmLabel.backgroundColor = UIColor.clearColor;
    _abmLabel.textColor = UIColor.whiteColor;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginSEG)];
    _abmLabel.userInteractionEnabled = YES;
    [_abmLabel addGestureRecognizer:tgr];
    
    [self.view addSubview:_abmLabel];
}

- (void)setupCreatedBy {
    UILabel *createdBy = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 42)];
    createdBy.text = @"Created By Samuel E. Giddins";
    createdBy.textColor = SEG_TEXT_COLOR;
    createdBy.backgroundColor = [UIColor clearColor];
    createdBy.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginSEG)];
    createdBy.userInteractionEnabled = YES;
    [createdBy addGestureRecognizer:tgr];
    [self. view addSubview:createdBy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
