//
//  KTALineGraphView.h
//  Keto
//
//  Created by Nelson LeDuc on 11/25/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTALineGraphView : UIView

@property (nonatomic, strong) NSArray *dataArray;

- (void)setupWithDataArray:(NSArray *)dataArray;
- (void)displayLineAnimated:(BOOL)animated;
- (void)addData:(NSNumber *)data;

@end
