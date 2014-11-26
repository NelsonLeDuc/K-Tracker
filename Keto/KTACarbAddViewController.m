//
//  FirstViewController.m
//  Keto
//
//  Created by Nelson LeDuc on 11/17/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "KTACarbAddViewController.h"
#import "KTACarb.h"
#import "KTACarbDailySource.h"

@interface KTACarbAddViewController ()

@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@property (nonatomic, weak) IBOutlet UITextField *labelTextField;
@property (nonatomic, weak) IBOutlet UITextField *carbTextField;

@end

@implementation KTACarbAddViewController

#pragma mark - Overrides

- (CGSize)preferredContentSize
{
    return CGSizeMake(0, CGRectGetMaxY(self.saveButton.frame) + 8.0 );
}

#pragma mark - Actions

- (IBAction)saveButtonPressed:(UIButton *)saveButton
{
    if (!self.carbTextField.text.length)
        return;
    
    NSDecimalNumber *carbDecimal = [NSDecimalNumber decimalNumberWithString:self.carbTextField.text];
    KTACarb *carb = [[KTACarb alloc] initWithLabel:self.labelTextField.text andCarbAmount:carbDecimal];
    
    [self.carbSource addCarb:carb];
    
    self.labelTextField.text = @"";
    self.carbTextField.text = @"";
}

@end
