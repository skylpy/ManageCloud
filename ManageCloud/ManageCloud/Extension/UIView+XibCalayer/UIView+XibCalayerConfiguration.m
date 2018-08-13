//
//  UIView+XibCalayerConfiguration.m
//  haibingo
//
//  Created by chendehui on 16/12/17.
//  Copyright © 2016年 innosky. All rights reserved.
//

#import "UIView+XibCalayerConfiguration.h"

@implementation UIView (XibCalayerConfiguration)

@dynamic borderColor,borderWidth,cornerRadius;

-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}
@end
