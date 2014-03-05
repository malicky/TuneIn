//
//  TIAppDelegate.h
//  TunedIn test
//
//  Created by Malick Youla on 2014-03-05.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <UIKit/UIKit.h>

// forward declarations
@class TIVimeoViewController;
@class AFHTTPClient;

@interface TIAppDelegate : UIResponder <UIApplicationDelegate>

// getters
- (AFHTTPClient *)getImageDownloader;

@property (strong, nonatomic) UIWindow *window;

// root view controller presenting parsed vimeo records
@property (strong, nonatomic) TIVimeoViewController *viewController;

@end
