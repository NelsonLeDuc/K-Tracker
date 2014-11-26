//
//  KTADataManager.m
//  Keto
//
//  Created by Nelson LeDuc on 11/26/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "KTADataManager.h"

@implementation KTADataManager

+ (NSArray *)savedDataArray
{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:@"dataArray"];
    return arr ?: @[];
}

+ (void)saveDataArray:(NSArray *)dataArray
{
    [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:@"dataArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
