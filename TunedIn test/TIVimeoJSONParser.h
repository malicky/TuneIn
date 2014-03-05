//
//  TIVimeoJSONParser.h
//  TunedIn test
//
//  Created by Malick Youla on 2014-03-05.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TIVimeoJSONParser : NSObject

+ (TIVimeoJSONParser *)sharedParser;

- (void)retrieveVideosPath:(NSString *)path parameters:(NSDictionary*)parameters
                          success:(void(^)(NSArray* results))successBlock
                          failure:(void(^)(NSError *error))failureBlock;


@end
