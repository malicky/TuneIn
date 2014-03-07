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
static NSString *supplementaryViewIdentifier = @"supplementaryViewIdentifier";
static NSString *cellIdentifier = @"Cell Identifier";

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
    
    
    [self.collectionView registerClass:[TIUserPortraitView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:supplementaryViewIdentifier];

    [self.collectionView registerClass:[TIVimeoCell class] forCellWithReuseIdentifier:cellIdentifier];


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
    return 1; //[self.datasource count]/kNumberOfRowsInSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.datasource count];//kNumberOfRowsInSection;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        TIVimeoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    // fetch
    NSDictionary *video = [self.datasource objectAtIndex:[indexPath section] * kNumberOfRowsInSection + [indexPath row]];
    NSLog(@" item at  %i, %i %@" ,indexPath.section, indexPath.row, video);
    
    // configure cell
    [cell setVideoDescrition:video];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    TIUserPortraitView *userView = nil;
    if (UICollectionElementKindSectionFooter) {
        
         userView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                            withReuseIdentifier:supplementaryViewIdentifier forIndexPath:indexPath];
         
         NSDictionary *video = [self.datasource objectAtIndex:[indexPath section] * kNumberOfRowsInSection + [indexPath row]];
        [userView setVideoDescrition:video];
    }
    
    return userView;
}

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
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8.0;
}
@end
