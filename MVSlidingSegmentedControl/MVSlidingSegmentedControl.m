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

@property BOOL isConfigured;
@property CGFloat initialTouchX;

@property (nonatomic) CGFloat baseSegmentOffset;
@property (nonatomic) CGFloat segmentWidth;

@end

@implementation MVSlidingSegmentedControl

- (void)setTitles:(NSArray *)titles
{
    NSAssert(titles.count >= 2 && titles.count <= 3, @"Only controls with 2 or 3 items are supported");
    _titles = titles;
    [self configure];
    [self createLabels:titles];
}

- (BOOL)isSegmentIndexValid:(NSUInteger)index {
    return index < self.labels.count;
}

#pragma mark - setters
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _segment.layer.borderColor = backgroundColor.CGColor;
}

- (void)setSegmentColor:(UIColor *)segmentColor
{
    _segmentColor = segmentColor;
    _segment.backgroundColor = segmentColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    _segment.layer.cornerRadius = cornerRadius;
}
- (void)setSegmentPadding:(CGFloat)segmentPadding
{
    _segmentPadding = segmentPadding;
    _segment.layer.borderWidth = segmentPadding;
}
- (void)setSelectedTitleFont:(UIFont *)selectedTitleFont
{
    _selectedTitleFont = selectedTitleFont;

    for (int i = 0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        if (i == _currentlySelectedIndex) {
            label.font = selectedTitleFont;
            break;
        }
    }
}

- (void)setUnselectedTitleFont:(UIFont *)unselectedTitleFont
{
    _unselectedTitleFont = unselectedTitleFont;

    for (int i = 0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        if (i != _currentlySelectedIndex) {
            label.font = unselectedTitleFont;
        }
    }
}

#pragma mark - configuration
- (void)createLabels:(NSArray *)items {

    for (UILabel *label in _labels) {
        [label removeFromSuperview];
    }

    _labels = [NSMutableArray new];
    for (NSString *title in items) {
        UILabel *label = [self labelWithTitle:title];
        [_labels addObject:label];
        [self addSubview:label];
    }
}

- (void)configure {

    if (_isConfigured) {
        return;
    }
    _isConfigured = YES;

    _currentlySelectedIndex = 0;

    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;

    [self createSegmentedControl];

    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]];
}

- (void)createSegmentedControl {
    _segment = [UIView new];
    _segment.backgroundColor = [UIColor whiteColor];
    _segment.layer.cornerRadius = 5;
    _segment.layer.masksToBounds = YES;
    _segment.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    _segment.layer.borderWidth = 2.0f;
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
}

- (void)layoutSegment {

    [_segment makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self);
        make.bottom.equalTo(self);
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

- (void)setCurrentlySelectedIndex:(NSUInteger)currentlySelectedIndex
{
    [self setCurrentlySelectedIndex:currentlySelectedIndex animated:NO];
}

- (void)setCurrentlySelectedIndex:(NSUInteger)currentlySelectedIndex animated:(BOOL)animated
{
    NSAssert(currentlySelectedIndex < self.labels.count, @"Try to set index out of bounds");
    if (_currentlySelectedIndex != currentlySelectedIndex) {
        [self updatedSelectedLabelFrom:_currentlySelectedIndex to:currentlySelectedIndex];
        _currentlySelectedIndex = currentlySelectedIndex;

        CGFloat segmentWidth = self.bounds.size.width / self.labels.count;
        [self updateSegmentLeftOffset:_currentlySelectedIndex * segmentWidth];
        if (animated) {
            [UIView animateWithDuration:kCompleteTransitionDuration animations:^{

                [_segment layoutIfNeeded];
            }];
        }
        else {
            [_segment layoutIfNeeded];
        }
    }
}
#pragma mark - touch handling

- (void)updatedSelectedLabelFrom:(NSUInteger)from to:(NSUInteger)to {

    if (self.unselectedTitleFont) {
        UILabel *oldLabel = self.labels[from];
        oldLabel.font = self.unselectedTitleFont;
    }
    if (self.selectedTitleFont) {
        UILabel *newLabel = self.labels[to];
        newLabel.font = self.selectedTitleFont;
    }
}

- (void)updateCurrentSegmentFrom:(NSUInteger)from to:(NSUInteger)to {

    [self updatedSelectedLabelFrom:from to:to];

    _currentlySelectedIndex = to;

    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if (self.didChangeSegmentBlock) {
        self.didChangeSegmentBlock(_currentlySelectedIndex);
    }
}

- (void)viewTapped:(UIGestureRecognizer *)gestureRecognizer {
    if (!_isConfigured) {
        return;
    }
    CGPoint point = [gestureRecognizer locationInView:self];
    NSUInteger page = (NSUInteger)(point.x / self.segmentWidth);
    if (page != _currentlySelectedIndex) {
        [self updateCurrentSegmentFrom:_currentlySelectedIndex to:page];

        CGFloat segmentWidth = self.bounds.size.width / self.labels.count;
        [self updateSegmentLeftOffset:_currentlySelectedIndex * segmentWidth];
        [UIView animateWithDuration:kCompleteTransitionDuration animations:^{

            [_segment layoutIfNeeded];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_isConfigured) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    self.initialTouchX = point.x;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_isConfigured) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat offset = point.x - self.initialTouchX;

    [self updateSegmentWithOffset:offset];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_isConfigured) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat offset = point.x - self.initialTouchX;

    [self completeSegmentTransitionWithOffset:offset];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_isConfigured) {
        return;
    }
    [self completeSegmentTransitionWithOffset:0];
}

#pragma mark - private methods
- (CGFloat)segmentWidth {
    return self.bounds.size.width / self.labels.count;
}
- (CGFloat)baseSegmentOffset {

    return self.segmentWidth * _currentlySelectedIndex;
}

- (void)updateSegmentLeftOffset:(CGFloat)leftOffset {

    [_segment updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(leftOffset);
    }];
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
    [self updateSegmentLeftOffset:newOffset];
    [_segment setNeedsLayout];
}

- (void)completeSegmentTransitionWithOffset:(CGFloat)offset {

    NSInteger steps = [self indexForTransitionComplete:offset];
    NSInteger newIndex = (NSInteger)_currentlySelectedIndex + steps;
    if (newIndex >= (NSInteger)self.labels.count) {
        newIndex = self.labels.count - 1;
    }
    else if (newIndex < 0) {
        newIndex = 0;
    }
    if (_currentlySelectedIndex != newIndex) {
        [self updateCurrentSegmentFrom:_currentlySelectedIndex to:(NSUInteger)newIndex];
    }

    CGFloat segmentWidth = self.bounds.size.width / self.labels.count;
    [self updateSegmentLeftOffset:_currentlySelectedIndex * segmentWidth];
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
