//
//  KTACarbContainerViewController.m
//  Keto
//
//  Created by Nelson LeDuc on 11/17/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "KTACarbContainerViewController.h"
#import "KTACarbAddViewController.h"
#import "KTACarbTableViewCell.h"
#import "KTACarbDailySource.h"

@interface KTACarbContainerViewController () <UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *currentCarbCountLabel;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *addButtonBottomConstraint;

@property (nonatomic, strong) KTACarbAddViewController *carbAddViewController;
@property (nonatomic, strong) KTACarbDailySource *carbSource;

@end

@implementation KTACarbContainerViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.carbSource = [[KTACarbDailySource alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [self.carbSource addCarbObserver:self withCallback:^(NSArray *carbs) {
        [weakSelf.tableView reloadData];
        [weakSelf updateCarbCountLabel];
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"KTACarbTableViewCell"  bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    [self createCarbAddViewController];
    [self createEffectsView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidChangeFrameNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSDictionary *userInfo = [note userInfo];
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGFloat yPosition = CGRectGetHeight(self.carbAddViewController.view.bounds) + CGRectGetHeight(endFrame);
        
        if (CGRectGetMinY(endFrame) >= CGRectGetHeight([[UIScreen mainScreen] bounds]))
        {
            yPosition = 0;
        }
        
        [self animateButtonToYPosition:yPosition withDuration:duration];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carbSource.allCarbs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KTACarbTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    [tableViewCell configureForCarb:self.carbSource.allCarbs[indexPath.row]];
    
    return tableViewCell;
}

#pragma mark - Actions

- (IBAction)addButtonPressed:(UIButton *)addButton
{
    [self.view endEditing:YES];
    
    CGFloat positon = ABS(self.addButtonBottomConstraint.constant) >= DBL_EPSILON ? 0.0 : CGRectGetHeight(self.carbAddViewController.view.bounds);
    [self animateButtonToYPosition:positon withDuration:0.2f];
}

#pragma mark - Private Methods

- (void)updateCarbCountLabel
{
    NSArray *carbAmmounts = [self.carbSource.allCarbs valueForKey:@"carbAmmount"];
    NSDecimalNumber *sum = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (NSDecimalNumber *decimalNumber in carbAmmounts)
    {
        sum = [sum decimalNumberByAdding:decimalNumber];
    }
    
    self.currentCarbCountLabel.text = [sum stringValue];
}

- (void)animateButtonToYPosition:(CGFloat)yPosition withDuration:(CGFloat)duration
{
    self.addButtonBottomConstraint.constant = yPosition;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)createEffectsView
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:effectView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.addButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.addButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.addButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.carbAddViewController.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    [self.view bringSubviewToFront:self.carbAddViewController.view];
    [self.view bringSubviewToFront:self.addButton];
}

- (void)createCarbAddViewController
{
    KTACarbAddViewController *carbAddViewController = [[KTACarbAddViewController alloc] init];
    carbAddViewController.carbSource = self.carbSource;
    carbAddViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:carbAddViewController.view];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:carbAddViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:carbAddViewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:carbAddViewController.preferredContentSize.height]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:carbAddViewController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:carbAddViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.addButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    self.carbAddViewController = carbAddViewController;
}

@end
