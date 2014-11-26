//
//  KTALineGraphView.m
//  Keto
//
//  Created by Nelson LeDuc on 11/25/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "KTALineGraphView.h"

@interface KTALineGraphView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIView *graphView;
@property (nonatomic, strong) NSArray *dataPoints;

@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *minLabel;

@end

@implementation KTALineGraphView

#pragma mark - Public Methods

- (void)setupWithDataArray:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    
    NSNumber *maxValue = [dataArray valueForKeyPath:@"@max.doubleValue"];
    NSNumber *minValue = [dataArray valueForKeyPath:@"@min.doubleValue"];
    self.dataPoints = [[self class] generateDataPointsFromDataArray:dataArray inMin:minValue andMax:maxValue];
    
    if (self.dataPoints.count < 2)
    {
        return;
    }
    
    [self drawShapeLayerWithDataPoints:self.dataPoints];
    
    [self setupLabelsWithMinValue:minValue maxValue:maxValue];
}

- (void)drawShapeLayerWithDataPoints:(NSArray *)dataPoints
{
    [self.shapeLayer removeFromSuperlayer];
    
    CGRect graphFrame = CGRectOffset(CGRectInset(self.bounds, 25, 0), 25, 0);
    UIView *graphView = [[UIView alloc] initWithFrame:graphFrame];
    [self addSubview:graphView];
    
    UIBezierPath *path = [[self class] pathFromDataPoints:dataPoints inRect:graphFrame];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.frame = graphView.bounds;
    shapeLayer.strokeColor = [[UIColor orangeColor] CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.allowsEdgeAntialiasing = YES;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.strokeEnd = 0.0;
    shapeLayer.masksToBounds = YES;
    shapeLayer.delegate = self;
    [graphView.layer addSublayer:shapeLayer];
    
    self.shapeLayer = shapeLayer;
}

- (void)addData:(NSNumber *)data
{
    NSArray *dataArray = [self.dataArray arrayByAddingObject:data];
    if (self.dataPoints.count < 2)
    {
        [self setupWithDataArray:dataArray];
        [self displayLineAnimated:YES];
        return;
    }
    
    [self.shapeLayer removeAnimationForKey:@"path"];
    
    
    self.dataArray = dataArray;
    
    NSNumber *maxValue = [dataArray valueForKeyPath:@"@max.doubleValue"];
    NSNumber *minValue = [dataArray valueForKeyPath:@"@min.doubleValue"];
    self.dataPoints = [[self class] generateDataPointsFromDataArray:dataArray inMin:minValue andMax:maxValue];
    
    UIBezierPath *path = [[self class] pathFromDataPoints:self.dataPoints inRect:CGRectOffset(CGRectInset(self.bounds, 25, 0), 25, 0)];
    
    [CATransaction begin];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    [animation setFromValue:(id)self.shapeLayer.path];
    animation.duration = 0.2;
    [animation setToValue:(id)path.CGPath];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:YES];
    [self.shapeLayer addAnimation:animation forKey:@"path"];
    [CATransaction setCompletionBlock:^{
        self.shapeLayer.path = path.CGPath;
        [self setupLabelsWithMinValue:minValue maxValue:maxValue];
    }];
    [CATransaction commit];
}

- (void)setupLabelsWithMinValue:(NSNumber *)min maxValue:(NSNumber *)max
{
    [self.maxLabel removeFromSuperview];
    [self.minLabel removeFromSuperview];
    
    UILabel *maxLabel = [[UILabel alloc] init];
    maxLabel.text = [max stringValue];
    maxLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:maxLabel];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[maxLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(maxLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[maxLabel]" options:0 metrics:@{ @"top" : @(CGRectGetHeight(self.bounds) * .1) } views:NSDictionaryOfVariableBindings(maxLabel)]];
    self.maxLabel = maxLabel;
    
    UILabel *minLabel = [[UILabel alloc] init];
    minLabel.text = [min stringValue];
    minLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:minLabel];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[minLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(minLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[minLabel]-top-|" options:0 metrics:@{ @"top" : @(CGRectGetHeight(self.bounds) * .1) } views:NSDictionaryOfVariableBindings(minLabel)]];
    self.minLabel = minLabel;
}

- (void)displayLineAnimated:(BOOL)animated
{
    if (!animated)
    {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        self.shapeLayer.strokeEnd = 1.0;
        [CATransaction commit];
    }
    else
    {
        self.shapeLayer.strokeEnd = 1.0;
    }
}

#pragma mark - Layer Delegate

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    if ([event isEqualToString:@"strokeEnd"])
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.duration = 2.0;
        return animation;
    }
    
    return nil;
}

#pragma mark - Class Methods

+ (NSArray *)generateDataPointsFromDataArray:(NSArray *)dataArray inMin:(NSNumber *)min andMax:(NSNumber *)max
{
    NSMutableArray *pointArray = [NSMutableArray array];
    
    CGFloat maxFloat = [max floatValue];
    CGFloat minFloat = [min floatValue];
    
    CGFloat total = [dataArray count] - 1;
    [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat numValue = [obj floatValue];
        CGFloat yPos = (1 - ((numValue - minFloat) / (maxFloat - minFloat))) * .7 + .15;
        CGFloat xPos = (idx / total);
        CGPoint point = CGPointMake(xPos, yPos);
        [pointArray addObject:[NSValue valueWithCGPoint:point]];
    }];
    
    return [NSArray arrayWithArray:pointArray];
}

+ (UIBezierPath *)pathFromDataPoints:(NSArray *)points inRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = [points.firstObject CGPointValue];
    CGFloat xPos = CGRectGetWidth(rect) * point.x;
    CGFloat yPos = CGRectGetHeight(rect) * point.y;
    [path moveToPoint:CGPointMake(xPos, yPos)];
    [points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx > 0)
        {
            CGPoint point = [obj CGPointValue];
            CGFloat xPos = CGRectGetWidth(rect) * point.x;
            CGFloat yPos = CGRectGetHeight(rect) * point.y;
            [path addLineToPoint:CGPointMake(xPos, yPos)];
        }
    }];
    
    return path;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    [self drawShapeLayerWithDataPoints:self.dataPoints];
    [self displayLineAnimated:NO];
}

@end
