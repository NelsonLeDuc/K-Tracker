//
//  KTACarbDailySource.h
//  Keto
//
//  Created by Nelson LeDuc on 11/17/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KTACarb;

@interface KTACarbDailySource : NSObject

@property (nonatomic, strong, readonly) NSArray *allCarbs;

- (void)addCarb:(KTACarb *)carb;
- (void)addCarbObserver:(id)observer withCallback:(void (^)(NSArray *))observerBlock;

@end
