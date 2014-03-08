//
//  TIUserPortraitView.m
//  TunedIn test
//
//  Created by Malick Youla on 2014-03-05.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "TIUserPortraitView.h"
#import "UIImageView+AFNetworking.h"
#import "TIAppDelegate.h"
#import "AFHTTPClient.h"
#import "NSMutableAttributedString+Helper.h"

@interface TIUserPortraitView ()

// description
@property (nonatomic, strong) UILabel *videoDescription;

@property (nonatomic, strong) NSString *userName; //user name
@property (nonatomic, strong) UIImageView *userPortrait; //  user thumbnail portrait

@end

@implementation TIUserPortraitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    CGRect bounds = self.bounds;
    
    // title
    CGRect titleFrame = CGRectMake(0.0, bounds.size.height - 16.0 , bounds.size.width, 16.0 *5 );
    self.videoDescription = [[UILabel alloc] initWithFrame:titleFrame];
    self.videoDescription.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.videoDescription.numberOfLines = 0;
    self.videoDescription.font = [UIFont fontWithName:@"GillSans" size:10.0];
    self.videoDescription.textAlignment = NSTextAlignmentLeft;
    self.videoDescription.textColor = [UIColor whiteColor];
    self.videoDescription.backgroundColor = [UIColor blackColor];
    [self addSubview:self.videoDescription];
    
    // thumbnail
    CGRect userPortraitFrame = CGRectMake(0., 20, bounds.size.width, bounds.size.height - 20.);
    self.userPortrait = [[UIImageView alloc] initWithFrame:userPortraitFrame];
    self.userPortrait.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.userPortrait.contentMode = UIViewContentModeScaleAspectFit;
    
    self.userPortrait.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userPortrait.layer.borderWidth = 1.0f;
    [self addSubview:self.userPortrait];
    
    return self;
}

- (void)setVideoDescrition:(NSDictionary *)video {
    if (_videoDescrition != video) {
        _videoDescrition = video;
        
        // subviews
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@""];
        NSString *user_name = video[@"user_name"];
        if(user_name) {
            
            [text appendAttributedString: [text TIVimeoFormatLabelString:@"Author: "]];
            [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:user_name]];
            [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
        }
        
        self.videoDescription.attributedText = text;
        [self.videoDescription sizeToFit];
        
        // download the image referenced in the url @"thumbnail_medium"
        //  build the request
        TIAppDelegate *appDelegate = (TIAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *path = _videoDescrition[@"user_portrait_medium"];
        NSMutableURLRequest *request = [[appDelegate getImageDownloader] requestWithMethod:@"GET"
                                                                                      path:path parameters:nil];
        
        __weak typeof(self) weakSelf = self;
        [weakSelf.userPortrait setImageWithURLRequest:request
                                      placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] // placehoder to use
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   // image download succesfull, set the thumbNailView
                                                   weakSelf.userPortrait.image = image;
                                                   
                                               } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                   static dispatch_once_t onceToken;
                                                   dispatch_once (&onceToken, ^{ // once, to prevent multiple alerts.
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                                                       message:NSLocalizedString(@"When downloading images", nil)
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:nil
                                                                                             otherButtonTitles:@"OK", nil];
                                                       [alert show];
                                                       weakSelf.userPortrait.image = nil;
                                                   });
                                               }];
        
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
