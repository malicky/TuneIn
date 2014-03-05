//
//  TIAppDelegate.m
//  TunedIn test
//
//  Created by Malick Youla on 2014-03-05.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "TIAppDelegate.h"

#import "TIVimeoJSONParser.h"
#import "TIVimeoViewController.h"

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

// base url to access the Vimeo API
static NSString *BaseURL = @"http://b.vimeocdn.com";

@interface TIAppDelegate ()

// http client for downloading images, base on a class of AFNetworking library
@property (nonatomic, strong) AFHTTPClient *downloader;

// JSON parser results
@property (nonatomic, strong) NSArray *resultsJSON;

@end


@implementation TIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.downloader = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
    
    NSString *path = @"album/58/videos.json";
    
    NSDictionary *parameters = @{
                                 @"page": @(1)
                                 };

    [[TIVimeoJSONParser sharedParser] retrieveVideosPath:path parameters:parameters
                                                      success:^(NSArray *descriptions) {
                                                          self.resultsJSON = descriptions;
                                                          NSLog(@"Success:\n%@", self.resultsJSON);
                                                          self.viewController = [[TIVimeoViewController alloc] initWithNibName:@"TIVimeoViewController" bundle:nil];
                                                          self.window.rootViewController = self.viewController;
                                                      } failure:^(NSError *error) {
                                                          NSLog(@"Failure\n%@", error);
                                                      }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (AFHTTPClient *)getImageDownloader {
    return self.downloader;
}

- (NSArray *)getVimeosDescriptions {
    return self.resultsJSON;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
