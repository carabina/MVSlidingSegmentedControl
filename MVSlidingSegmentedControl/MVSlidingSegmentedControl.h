//
//  MVSlidingSegmentedControl.h
//  MVSlidingSegmentedControl
//
//  Created by Andrea Bizzotto on 18/08/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVSlidingSegmentedControl : UIControl

- (id)initWithItems:(NSArray *)items;

@property(strong, nonatomic) NSArray *titles;

@property (nonatomic) NSUInteger currentlySelectedIndex;

- (void)setCurrentlySelectedIndex:(NSUInteger)currentlySelectedIndex animated:(BOOL)animated;
- (BOOL)isSegmentIndexValid:(NSUInteger)index;

@property (strong) void (^segmentDidChangeBlock)(NSUInteger currentlySelectedIndex);

@end
