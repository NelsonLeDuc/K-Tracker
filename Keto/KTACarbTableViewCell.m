//
//  KTACarbTableViewCell.m
//  Keto
//
//  Created by Nelson LeDuc on 11/17/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "KTACarbTableViewCell.h"
#import "KTACarb.h"

@interface KTACarbTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *carbLabel;
@property (nonatomic, weak) IBOutlet UILabel *labelLabel;

@end

@implementation KTACarbTableViewCell

- (void)configureForCarb:(KTACarb *)carb
{
    self.carbLabel.text = [carb.carbAmmount stringValue];
    self.labelLabel.text = carb.labelString;
}

@end
