//
//  KTACarb.h
//  Keto
//
//  Created by Nelson LeDuc on 11/17/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTACarb : NSObject

@property (nonatomic, strong, readonly) NSString *labelString;
@property (nonatomic, strong, readonly) NSDecimalNumber *carbAmmount;

- (instancetype)initWithLabel:(NSString *)labelOrNil andCarbAmount:(NSDecimalNumber *)carbAmmount;

@end
