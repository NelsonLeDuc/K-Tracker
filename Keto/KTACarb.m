//
//  KTACarb.m
//  Keto
//
//  Created by Nelson LeDuc on 11/17/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "KTACarb.h"

@implementation KTACarb

- (instancetype)initWithLabel:(NSString *)labelOrNil andCarbAmount:(NSDecimalNumber *)carbAmmount
{
    self = [super init];
    if (self)
    {
        _labelString = labelOrNil;
        _carbAmmount = carbAmmount;
    }
    
    return self;
}

@end
