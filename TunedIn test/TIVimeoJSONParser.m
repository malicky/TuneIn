//
//  TIVimeoJSONParser.m
//  TunedIn test
//
//  Created by Malick Youla on 2014-03-05.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "TIVimeoJSONParser.h"

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

// base url Vimeo API
static NSString *BaseURL = @"http://vimeo.com/api/v2/";

@interface TIVimeoJSONParser ()

// AFHTTPClient to GET and parse JSON
@property (nonatomic, strong) AFHTTPClient *client;

@end

@implementation TIVimeoJSONParser

#pragma mark - Singleton

+ (TIVimeoJSONParser *)sharedParser {
    static TIVimeoJSONParser *parser = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser = [[TIVimeoJSONParser alloc] init];
    });
    
    return parser;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // Initialise
    self.client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
    // set to JSON type
    [self.client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    return self;
}

- (void)retrieveVideosPath:(NSString *)path parameters:(NSDictionary *)parameters
                          success:(void(^)(NSArray* results))successBlock
                          failure:(void(^)(NSError *error))failureBlock {
    
    [self.client getPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     if (![responseObject isKindOfClass:[NSArray class]]) {
                         if (failureBlock) {
                             failureBlock(nil);
                         }
                         return;
                     }
                     
                     NSArray *descriptions = (NSArray *)responseObject;
                     if (successBlock) {
                         successBlock(descriptions);
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     if (failureBlock) {
                         failureBlock(error);
                     }
                 }];
    
    
    
}
@end

