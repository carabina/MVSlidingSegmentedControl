//
//  MVSlidingSegmentedControl.m
//  MVSlidingSegmentedControl
//
//  Created by Andrea Bizzotto on 18/08/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

#import "MVSlidingSegmentedControl.h"
#import "MASConstraint.h"
#import "MASConstraintMaker.h"
#import "View+MASShorthandAdditions.h"

static NSTimeInterval kCompleteTransitionDuration = 0.2;

@interface MVSlidingSegmentedControl()
@property(nonatomic) BOOL constraintsSet;
@property(strong, nonatomic) NSMutableArray *labels;
@property(strong, nonatomic) UIView *segment;

@property NSUInteger currentlySelectedIndex;
@property CGFloat initialTouchX;

@property (nonatomic) CGFloat baseSegmentOffset;
@property (nonatomic) CGFloat segmentWidth;

@end

@implementation MVSlidingSegmentedControl

- (id)initWithItems:(NSArray *)items {

    NSAssert(items.count >= 2 && items.count <= 3, @"Only controls with 2 or 3 items are supported");
    if (self = [super init]) {

        [self configure];
        [self createSegmentedControl];
        [self createLabels:items];

    }
    return self;
}

- (void)createLabels:(NSArray *)items {

    _labels = [NSMutableArray new];
    for (NSString *title in items) {
        UILabel *label = [self labelWithTitle:title];
        [_labels addObject:label];
        [self addSubview:label];
    }
}

- (void)configure {

    _currentlySelectedIndex = 0;

    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)createSegmentedControl {
    _segment = [UIView new];
    _segment.backgroundColor = [UIColor whiteColor];
    _segment.layer.cornerRadius = 5;
    _segment.layer.masksToBounds = YES;
    [self addSubview:_segment];
}

- (UILabel *)labelWithTitle:(NSString *)title {

    UILabel *label = [UILabel new];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    return label;
}

- (void)updateConstraints
{
    [super updateConstraints];
    if (_constraintsSet) {
        return;
    }
    _constraintsSet = YES;

    [self layoutSegment];
    [self layoutLabels];

    NSLog(@"%s", __func__);
}

- (void)layoutSegment {

    CGFloat offset = 2;
    [_segment makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self).offset(offset);
        make.bottom.equalTo(self).offset(-offset);
        make.width.equalTo(self).dividedBy(_labels.count);
        make.left.equalTo(self.left);
    }];
}

- (void)layoutLabels {

    for (int i = 0; i < _labels.count; i++) {
        UILabel *label = _labels[i];

        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self).dividedBy(_labels.count);
        }];
    }
    UILabel *leftLabel = _labels[0];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
    }];
    UILabel *rightLabel = _labels[_labels.count - 1];
    [rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
    }];

    if (_labels.count == 3) {
        UILabel *centerLabel = _labels[1];
        [centerLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
        }];
    }
    // TODO: 4 items!
}

#pragma mark - touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    self.initialTouchX = point.x;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat offset = point.x - self.initialTouchX;

    [self updateSegmentWithOffset:offset];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    CGFloat offset = point.x - self.initialTouchX;

    [self completeSegmentTransitionWithOffset:offset];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self completeSegmentTransitionWithOffset:0];
}

#pragma mark - private methods
- (CGFloat)segmentWidth {
    return self.bounds.size.width / self.labels.count;
}
- (CGFloat)baseSegmentOffset {

    return self.segmentWidth * _currentlySelectedIndex;
}

- (void)updateSegmentWithOffset:(CGFloat)offset {

    CGFloat newOffset = offset + [self baseSegmentOffset];
    CGFloat maxOffset = self.segmentWidth * (self.labels.count - 1);
    if (newOffset > maxOffset) {
        newOffset = maxOffset;
    }
    else if (newOffset < 0) {
        newOffset = 0;
    }
    [_segment updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(newOffset);
    }];
    [_segment setNeedsLayout];
}

- (void)completeSegmentTransitionWithOffset:(CGFloat)offset {

    NSInteger steps = [self indexForTransitionComplete:offset];
    NSInteger newIndex = _currentlySelectedIndex + steps;
    if (newIndex >= self.labels.count) {
        newIndex = self.labels.count - 1;
    }
    else if (newIndex < 0) {
        newIndex = 0;
    }
    if (_currentlySelectedIndex != newIndex) {
        _currentlySelectedIndex = (NSUInteger)newIndex;
        // Delegate call
    }

    CGFloat segmentWidth = self.bounds.size.width / self.labels.count;
    [_segment updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(_currentlySelectedIndex * segmentWidth);
    }];
    [UIView animateWithDuration:kCompleteTransitionDuration animations:^{

        [_segment layoutIfNeeded];
    }];
}

- (NSInteger)indexForTransitionComplete:(CGFloat)offset {

    // Take position corresponding to centerX of previous segment state
    CGFloat segmentWidth = self.bounds.size.width / self.labels.count;
    if (offset > 0) {
        return (NSInteger)roundf(offset / segmentWidth);
    }
    else {
        return -(NSInteger)roundf(-offset / segmentWidth);
    }
}

@end
