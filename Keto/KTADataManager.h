//
//  KTADataManager.h
//  Keto
//
//  Created by Nelson LeDuc on 11/26/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTADataManager : NSObject

+ (NSArray *)savedDataArray;
+ (void)saveDataArray:(NSArray *)dataArray;

@end
