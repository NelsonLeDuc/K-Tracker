//
//  KTACarbTableViewCell.h
//  Keto
//
//  Created by Nelson LeDuc on 11/17/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTACarb;

@interface KTACarbTableViewCell : UITableViewCell

- (void)configureForCarb:(KTACarb *)carb;

@end
