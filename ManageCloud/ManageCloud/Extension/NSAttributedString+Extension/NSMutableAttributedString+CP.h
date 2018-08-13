//
//  NSMutableAttributedString+CP.h
//  intelMeeting
//
//  Created by Mr.Aaron on 2018/3/2.
//  Copyright © 2018年 张子恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString (CP)


/**

 @param str 特殊字符串
 @param content 其他内容
 @param color 特殊字符串颜色
 @param font 特殊字符串字体
 @param size 特殊字符串大小
 */
+ (NSMutableAttributedString *)GetStringWithFormat:(NSString *)str withContent:(NSString *)content withTextColor:(UIColor *)color withFont:(NSString *)font withFontSize:(CGFloat)size;
@end
