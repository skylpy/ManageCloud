//
//  CustomString.m
//  ManageCloud
//
//  Created by aaron on 2018/5/29.
//  Copyright © 2018年 张子恒. All rights reserved.
//

#import "CustomString.h"

@implementation CustomString

+ (NSArray *)sort:(NSArray *)array {

    NSMutableArray * array1 = [NSMutableArray array];

    for (NSDictionary * dic in array) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        NSInteger time = [self timeSwitchTimestamp:dic[@"GDATE"] andFormatter:@"YYYY-MM-dd hh:mm:ss"];
        [dict setValue:dic[@"GDATE"] forKey:@"GDATE"];
        [dict setValue:@(time) forKey:@"GDATETime"];
        [dict setValue:dic[@"OID"] forKey:@"OID"];
        [dict setValue:dic[@"Title"] forKey:@"Title"];
        [dict setValue:dic[@"DayTime"] forKey:@"DayTime"];
        [dict setValue:dic[@"AttachCount"] forKey:@"AttachCount"];
        [dict setValue:dic[@"REPLYCON"] forKey:@"REPLYCON"];
        [dict setValue:dic[@"Sex"] forKey:@"Sex"];

        [array1 addObject:dict];
    }

//
    // 获取array中所有index值
    NSArray *indexArray = [array1 valueForKey:@"GDATETime"];
    // 将array装换成NSSet类型
    NSSet *indexSet = [NSSet setWithArray:indexArray];
    // 新建array，用来存放分组后的array
    NSMutableArray *resultArray = [NSMutableArray array];
    // NSSet去重并遍历
    [[indexSet allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 根据NSPredicate获取array
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"GDATETime == %@",obj];
        NSArray *indexArray = [array1 filteredArrayUsingPredicate:predicate];
        
        // 将查询结果加入到resultArray中
        [resultArray addObject:indexArray];
    }];
    NSMutableArray * listA = [NSMutableArray array];
    for (NSArray *list in resultArray) {
        NSMutableDictionary * dicts = [NSMutableDictionary dictionary];
        dicts[@"time"] = list[0][@"GDATETime"];
        dicts[@"list"] = list;
        [listA addObject:dicts];
    }
    
    NSArray *sortResultArr = [listA sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        NSComparisonResult result = [obj2[@"time"] compare:obj1[@"time"]];
        
        if (result == NSOrderedSame) {
            result = [obj2[@"list"] compare:obj1[@"list"]];
        }
        return result;
    }];
    
    NSMutableArray * resultDataSoure = [NSMutableArray array];
    for (NSDictionary * resultDic in sortResultArr) {
        [resultDataSoure addObject:resultDic[@"list"]];
    }
//    NSLog(@"===%@",resultDataSoure);
    
    return resultDataSoure;
}

//将某个时间转化成 时间戳

#pragma mark - 将某个时间转化成 时间戳

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    
    
    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    
    
    
    return timeSp;
    
}

@end
