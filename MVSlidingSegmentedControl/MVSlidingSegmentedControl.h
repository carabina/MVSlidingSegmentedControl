//
//  MVSlidingSegmentedControl.h
//  MVSlidingSegmentedControl
//
//  Created by Andrea Bizzotto on 18/08/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVSlidingSegmentedControl : UIControl

// Mandatory property (needs to be set for the segmented control to be configured)
@property(strong, nonatomic) NSArray *titles;

@property (nonatomic) NSUInteger selectedSegmentIndex;

- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex animated:(BOOL)animated;
- (BOOL)isSegmentIndexValid:(NSUInteger)index;

@property (strong) void (^didChangeSegmentBlock)(NSUInteger selectedSegmentIndex);

// UI Properties
@property(copy, nonatomic) UIColor *backgroundColor;
@property(copy, nonatomic) UIColor *segmentColor;
@property(copy, nonatomic) UIColor *borderColor;
@property(nonatomic) CGFloat cornerRadius;
@property(nonatomic) CGFloat segmentPadding;
@property(strong, nonatomic) UIFont *selectedTitleFont;
@property(strong, nonatomic) UIFont *unselectedTitleFont;
@end
