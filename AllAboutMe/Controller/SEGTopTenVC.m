//
//  SEGTopTenVC.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/29/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGTopTenVC.h"
#import "SEGCollectionViewCell.h"
#import "SEGUser.h"

@interface SEGTopTenVC ()

@end

@implementation SEGTopTenVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    if (self = [super initWithCollectionViewLayout:layout]) {
        layout.itemSize = CGSizeMake(125, 125);
        [self.collectionView registerClass:[SEGCollectionViewCell class] forCellWithReuseIdentifier:@"Top Ten Cell"];
        [(UICollectionViewFlowLayout *)layout setSectionInset:UIEdgeInsetsMake(15, 20, 10, 20)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.title = [NSString stringWithFormat:@"%@'s Top Tens", [[SEGUser currentUser] username]];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SEGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Top Ten Cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            [cell setTitle:@"Songs"];
            break;
            
        case 1:
            [cell setTitle:@"Apps"];
            break;
            
        case 2:
            [cell setTitle:@"Movies"];
            break;
            
        case 3:
            [cell setTitle:@"TV Shows"];
            break;
            
        case 4:
            [cell setTitle:@"Books"];
            break;
            
        default:
            [cell setTitle:nil];
            [cell setImage:nil];
            break;
    }
    
    return cell;
}

@end
