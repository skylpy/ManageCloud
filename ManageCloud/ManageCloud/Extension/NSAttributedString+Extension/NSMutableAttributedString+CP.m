//
//  NSMutableAttributedString+CP.m
//  intelMeeting
//
//  Created by Mr.Aaron on 2018/3/2.
//  Copyright © 2018年 张子恒. All rights reserved.
//

#import "NSMutableAttributedString+CP.h"


@implementation NSMutableAttributedString (CP)


+ (NSMutableAttributedString *)GetStringWithFormat:(NSString *)str withContent:(NSString *)content withTextColor:(UIColor *)color withFont:(NSString *)font withFontSize:(CGFloat)size {
    
    NSString *string = [NSString stringWithFormat:@"%@%@",str,content];
    
    
    //获取需要改变的字符串在完整字符串的范围
    NSRange rang = [string rangeOfString:str];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    //设置文字颜色
    [text addAttribute:NSForegroundColorAttributeName value:color range:rang];
    
    //设置文字大小
    [text addAttribute:NSFontAttributeName value:font range:rang];
    
    return text;
}

@end
