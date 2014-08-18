//
//  ViewController.m
//  MVSlidingSegmentedControl
//
//  Created by Andrea Bizzotto on 18/08/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

#import <Masonry/View+MASShorthandAdditions.h>
#import "ViewController.h"
#import "MVSlidingSegmentedControl.h"
#import "MASConstraintMaker.h"

@interface ViewController ()
@property(strong, nonatomic) MVSlidingSegmentedControl *control;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.control = [[MVSlidingSegmentedControl alloc] initWithItems:@[@"Left", @"Center", @"Right"]];
    [self.view addSubview:self.control];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];

    [self.control makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.view).offset(100);
        make.width.equalTo(@300);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@44);
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
