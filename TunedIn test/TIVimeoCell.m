//
//  TIVimeoCell.m
//  TunedIn test
//
//  Created by Malick Youla on 2014-03-05.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "TIVimeoCell.h"

#import "UIImageView+AFNetworking.h"
#import "TIAppDelegate.h"
#import "AFHTTPClient.h"
#import "NSMutableAttributedString+Helper.h"

static int kMaxCharDescription = 100;

@interface TIVimeoCell ()

// description
@property (nonatomic, strong) UILabel *videoDescription;

// Video
@property (nonatomic, strong) NSString *titleLabel; // title
@property (nonatomic, strong) NSString *description; // description
@property (nonatomic, strong) NSString *uploadDate; //upload date
@property (nonatomic, strong) NSString *userName; //user name
@property (nonatomic, strong) UIImageView *userPortrait; //  user thumbnail portrait
@property (nonatomic, strong) UIImageView *thumbNailView; // video thumbnail image

@end

@implementation TIVimeoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    CGRect bounds = self.contentView.bounds;
    
    // title
    CGRect titleFrame = CGRectMake(0.0, bounds.size.height - 16.0, bounds.size.width, 16.0 *5 );
    self.videoDescription = [[UILabel alloc] initWithFrame:titleFrame];
    self.videoDescription.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.videoDescription.numberOfLines = 0;
    self.videoDescription.font = [UIFont fontWithName:@"GillSans" size:10.0];
    self.videoDescription.textAlignment = NSTextAlignmentLeft;
    self.videoDescription.textColor = [UIColor whiteColor];
    self.videoDescription.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.videoDescription];
    
    // thumbnail
    CGRect thumbnailFrame = CGRectMake(0., 0., bounds.size.width, bounds.size.height - 20.);
    self.thumbNailView = [[UIImageView alloc] initWithFrame:thumbnailFrame];
    self.thumbNailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.thumbNailView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.thumbNailView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.thumbNailView.layer.borderWidth = 1.0f;
    
    [self.contentView addSubview:self.thumbNailView];
        
    return self;
}


- (void)setVideoDescrition:(NSDictionary *)video {
    if (_videoDescrition != video) {
        _videoDescrition = video;
        
        // subviews
         NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@""];
        
        NSString *title = video[@"title"];
        NSString *description = video[@"description"];
        NSString *upload_date = video[@"upload_date"];
        

        // build the description text by concatenation
        if(title) {
            [text appendAttributedString: [text TIVimeoFormatLabelString:@"Title: "]];
            [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:title]];
            [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
 
        }
        if(description) {
            description = [description stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
            description = [description stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            if ([description length] >= kMaxCharDescription) {// cut too long descriptions
                NSRange stringRange = {0, MIN([description length], kMaxCharDescription)};
                stringRange = [description rangeOfComposedCharacterSequencesForRange:stringRange];
                description = [description substringWithRange:stringRange];
                description = [description stringByAppendingString:@"..."];
            }
            
            [text appendAttributedString: [text TIVimeoFormatLabelString:@"About: "]];
            [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:description]];
            [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];

        }
        if(upload_date) {
            [text appendAttributedString: [text TIVimeoFormatLabelString:@"Date: "]];
            [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:upload_date]];
            [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
        }
     
        
        self.videoDescription.attributedText = text;
       [self.videoDescription sizeToFit];
        
        // download the image referenced in the url @"thumbnail_medium"
        //  build the request
        TIAppDelegate *appDelegate = (TIAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *path = _videoDescrition[@"thumbnail_medium"];
        NSMutableURLRequest *request = [[appDelegate getImageDownloader] requestWithMethod:@"GET"
                                                                                  path:path parameters:nil];
        
        __weak typeof(self) weakSelf = self;
        [weakSelf.thumbNailView setImageWithURLRequest:request
                                      placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] // placehoder to use
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   // image download succesfull, set the thumbNailView
                                                   weakSelf.thumbNailView.image = image;
                                                   
                                               } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                   static dispatch_once_t onceToken;
                                                   dispatch_once (&onceToken, ^{ // once, to prevent multiple alerts.
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                                                       message:NSLocalizedString(@"When downloading images", nil)
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:nil
                                                                                             otherButtonTitles:@"OK", nil];
                                                       [alert show];
                                                       weakSelf.thumbNailView.image = nil;
                                                   });
                                               }];
        
        
    }
}


@end
