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

@property (nonatomic) NSUInteger currentlySelectedIndex;

- (void)setCurrentlySelectedIndex:(NSUInteger)currentlySelectedIndex animated:(BOOL)animated;
- (BOOL)isSegmentIndexValid:(NSUInteger)index;

@property (strong) void (^segmentDidChangeBlock)(NSUInteger currentlySelectedIndex);

// UI Properties
@property(copy, nonatomic) UIColor *backgroundColor;
@property(copy, nonatomic) UIColor *segmentColor;
@property(nonatomic) CGFloat cornerRadius;
@property(nonatomic) CGFloat segmentPadding;
@property(strong, nonatomic) UIFont *selectedTitleFont;
@property(strong, nonatomic) UIFont *unselectedTitleFont;
@end
