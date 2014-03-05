//
//  TIVimeoViewController.m
//  TunedIn test
//
//  Created by Malick Youla on 2014-03-05.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "TIVimeoViewController.h"

#import "TIVimeoJSONParser.h"
#import "TIAppDelegate.h"
#import "TIVimeoCell.h"
#import "TIUserPortraitView.h"

static int kNumberOfRowsInSection = 2;


@interface TIVimeoViewController ()

@property (nonatomic, strong) NSArray *datasource;

@end

@implementation TIVimeoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *path = @"album/58/videos.json";
    
    NSDictionary *parameters = @{
                                 @"page": @(1)
                                 };
    
    [[TIVimeoJSONParser sharedParser] retrieveVideosPath:path parameters:parameters
                                                 success:^(NSArray *descriptions) {
                                                     NSLog(@"Success:\n%@", descriptions);
                                                     // set datasource to JSON array
                                                     self.datasource = descriptions;
                                                     // force the call of delegate methods with data from datasource
                                                     [self.collectionView reloadData];
                                                 } failure:^(NSError *error) {
                                                     NSLog(@"Failure\n%@", error);
                                                 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Collection View Data Source Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.datasource count]/kNumberOfRowsInSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kNumberOfRowsInSection;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell Identifier";
    [collectionView registerClass:[TIVimeoCell class] forCellWithReuseIdentifier:cellIdentifier];
    TIVimeoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    // fetch
    NSDictionary *video = [self.datasource objectAtIndex:[indexPath section] * kNumberOfRowsInSection + [indexPath row]];
    NSLog(@" item at  %i, %i %@" ,indexPath.section, indexPath.row, video);
    
    // configure cell
    [cell setVideoDescrition:video];
    
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind
//                                 atIndexPath:(NSIndexPath *)indexPath {
//    static NSString *supplementaryViewIdentifier = @"supplementaryViewIdentifier";
//    [self.collectionView registerNib:[UINib nibWithNibName:@"TIUserPortraitView" bundle:nil] forCellWithReuseIdentifier:supplementaryViewIdentifier];
//    TIUserPortraitView *userView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:supplementaryViewIdentifier forIndexPath:indexPath];
//    
//    NSDictionary *video = [self.datasource objectAtIndex:[indexPath section] * kNumberOfRowsInSection + [indexPath row]];
//    userView.userLabel.text = [video objectForKey:@"user_name"];
//    
//    return userView;
//}

#pragma mark -
#pragma mark Collection View Delegate Methods

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(125.0, 125.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(25.0, 25.0, 50.0, 25.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8.0;
}
@end
