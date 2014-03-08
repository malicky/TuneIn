//
//  NSMutableAttributedString+Helper.h
//  TunedIn test
//
//  Created by Malick Youla on 2014-03-08.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Helper)

- (void)addFont:(UIFont *)font forSubstring:(NSString *)substring;
- (NSMutableAttributedString *)TIVimeoFormatLabelString:(NSString*)string;
@end
