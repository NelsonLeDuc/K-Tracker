//
//  KTACarbDailySource.m
//  Keto
//
//  Created by Nelson LeDuc on 11/17/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "KTACarbDailySource.h"

@interface KTACarbDailySource ()

@property (nonatomic, strong, readwrite) NSArray *allCarbs;
@property (nonatomic, strong) NSMapTable *observerTable;

@end

@implementation KTACarbDailySource

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.allCarbs = [NSArray array];
        self.observerTable = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)addCarb:(KTACarb *)carb
{
    self.allCarbs = [self.allCarbs arrayByAddingObject:carb];
    
    [self notifyObservers];
}

- (void)addCarbObserver:(id)observer withCallback:(void (^)(NSArray *))observerBlock
{
    if (!observerBlock || !observer)
        return;
    
    [self.observerTable setObject:observerBlock forKey:observer];
}

#pragma mark - Private Methods

- (void)notifyObservers
{
    
    NSEnumerator *objectEnumerator = [self.observerTable objectEnumerator];
    void (^callback)(NSArray *);
    while (( callback = objectEnumerator.nextObject))
    {
        callback(self.allCarbs);
    }
}

@end
