//
//  NSAttributedString+Ectension.h
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/18.
//  Copyright © 2018年 张子恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (Ectension)

+ (NSMutableAttributedString *)allConentStr:(NSString *)allStr withAttStr:(NSString *)attStr;

+ (NSMutableAttributedString *)allConentStr:(NSString *)allStr withAttStr:(NSString *)attStr withAcolor:(UIColor *)color;

@end
