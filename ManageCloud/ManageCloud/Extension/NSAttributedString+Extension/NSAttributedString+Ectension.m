//
//  NSAttributedString+Ectension.m
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/18.
//  Copyright © 2018年 张子恒. All rights reserved.
//

#import "NSAttributedString+Ectension.h"


@implementation NSAttributedString (Ectension)

+ (NSMutableAttributedString *)allConentStr:(NSString *)allStr withAttStr:(NSString *)attStr {

    //从字符串中找到审核、回复
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    
    NSRange range;
    
    //判断字符串中有没有回复
    
    if([allStr rangeOfString:attStr].location !=NSNotFound){
        
        range = [allStr rangeOfString:attStr];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor redColor]
         
                              range:NSMakeRange(range.location, range.length)];
        
    }
    
    else{//没有回复那就默认判断审核
        
        range = [allStr rangeOfString:attStr];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor redColor]
         
                              range:NSMakeRange(range.location, range.length)];
        
    }
    
    return AttributedStr;
}

+ (NSMutableAttributedString *)allConentStr:(NSString *)allStr withAttStr:(NSString *)attStr withAcolor:(UIColor *)color {
    
    //从字符串中找到审核、回复
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    
    NSRange range;
    
    //判断字符串中有没有回复
    
    if([allStr rangeOfString:attStr].location !=NSNotFound){
        
        range = [allStr rangeOfString:attStr];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:color
         
                              range:NSMakeRange(range.location, range.length)];
        
    }
    
    else{//没有回复那就默认判断审核
        
        range = [allStr rangeOfString:attStr];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:color
         
                              range:NSMakeRange(range.location, range.length)];
        
    }
    
    return AttributedStr;
}

@end
