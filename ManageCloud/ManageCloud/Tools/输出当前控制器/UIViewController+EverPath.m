//
//  UIViewController+EverPath.m
//  EverShowPath
//
//  Pingzi
//


/**
 *  运行时打印当前控制器的名称
 */

#import "UIViewController+EverPath.h"
#import <objc/runtime.h>

#define kPrintPathLog (1)

@implementation UIViewController (EverPath)

+ (void)load
{
#ifdef DEBUG
#if kPrintPathLog == 1
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        Method m1 = class_getInstanceMethod(cls, @selector(viewDidLoad));
        Method m2 = class_getInstanceMethod(cls, @selector(ViewDidLoad_EverPath));
        method_exchangeImplementations(m1, m2);
    });
#endif
#endif
}

- (void)ViewDidLoad_EverPath
{
    [self ViewDidLoad_EverPath];
    printf("Ever_VC_Path:%s\n",NSStringFromClass(self.class).UTF8String);
}

@end
