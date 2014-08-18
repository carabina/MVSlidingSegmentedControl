//
//  ViewController.m
//  MVSlidingSegmentedControl
//
//  Created by Andrea Bizzotto on 18/08/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

#import "ViewController.h"
#import "MVSlidingSegmentedControl.h"

@interface ViewController ()
@property(strong, nonatomic) IBOutlet MVSlidingSegmentedControl *segmentedControl;
- (IBAction)newPageSelected:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)prevButtonPressed:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.segmentedControl.titles = @[@"Left", @"Center", @"Right"];
    // Use this for block based notifications
//    self.segmentedControl.segmentDidChangeBlock = ^(NSUInteger currentlySelectedIndex) {
//
//        NSLog(@"new page: %d", self.segmentedControl.currentlySelectedIndex);
//    };
}

- (IBAction)newPageSelected:(id)sender {

    NSLog(@"new page: %d", self.segmentedControl.currentlySelectedIndex);
}

- (IBAction)nextButtonPressed:(id)sender {

    NSUInteger nextIndex = self.segmentedControl.currentlySelectedIndex + 1;
    if ([self.segmentedControl isSegmentIndexValid:nextIndex]) {
        [self.segmentedControl setCurrentlySelectedIndex:nextIndex animated:YES];
    }
}
- (IBAction)prevButtonPressed:(id)sender {

    if (self.segmentedControl.currentlySelectedIndex > 0) {
        [self.segmentedControl setCurrentlySelectedIndex:self.segmentedControl.currentlySelectedIndex - 1 animated:YES];
    }
}

@end
