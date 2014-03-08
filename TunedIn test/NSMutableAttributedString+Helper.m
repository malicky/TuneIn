//
//  NSMutableAttributedString+Helper.m
//  TunedIn test
//
//  Created by Malick Youla on 2014-03-08.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "NSMutableAttributedString+Helper.h"

@implementation NSMutableAttributedString (Helper)

- (void)addFont:(UIFont *)font forSubstring:(NSString *)substring {
    NSRange range = [self.string rangeOfString:substring];
    if (range.location != NSNotFound) {
        [self addAttribute: NSFontAttributeName
                     value:font
                     range:range];
    }
}

- (NSMutableAttributedString *)TIVimeoFormatLabelString:(NSString*)string {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *label = [[NSMutableAttributedString alloc] initWithString:string];
    [label addFont:[UIFont boldSystemFontOfSize:12.0] forSubstring:string];
    [text appendAttributedString:label];
    
    return text;
}
@end
