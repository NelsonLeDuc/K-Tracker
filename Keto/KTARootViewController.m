//
//  KTARootViewController.m
//  Keto
//
//  Created by Nelson LeDuc on 11/25/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "KTARootViewController.h"
#import "KTALineGraphView.h"
#import "KetoTrack-Swift.h"

@interface KTARootViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet KTALineGraphView *lineGraphView;
@property (nonatomic, weak) IBOutlet UITextField *weightField;

@end

@implementation KTARootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray *data = [DataManager savedDataArray];
    
    [self.lineGraphView setupWithDataArray:data];
    [self.lineGraphView displayLineAnimated:NO];
}

#pragma mark - Actions

- (IBAction)addButtonPressed:(UIButton *)addButton
{
    if (!self.weightField.text.length)
        return;
    
    NSNumber *value = [NSNumber numberWithDouble:[self.weightField.text doubleValue]];
    
    [self.view endEditing:NO];
    self.weightField.text = @"";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.lineGraphView addData:value];
        [DataManager saveDataArray:self.lineGraphView.dataArray];
    });
}

#pragma mark - Handle Keyboard

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 20, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
