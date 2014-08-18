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
@property(strong, nonatomic) IBOutlet MVSlidingSegmentedControl *topSegmentedControl;
@property(strong, nonatomic) IBOutlet UILabel *topLabel;
- (IBAction)topSegmentSelected:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)prevButtonPressed:(id)sender;

@property(strong, nonatomic) IBOutlet MVSlidingSegmentedControl *bottomSegmentedControl;
@property(strong, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


    self.topSegmentedControl.titles = @[@"Left", @"Center", @"Right"];
    self.topSegmentedControl.selectedTitleFont = [UIFont boldSystemFontOfSize:16];
    self.topSegmentedControl.unselectedTitleFont = [UIFont systemFontOfSize:16];
    self.topSegmentedControl.backgroundColor = [UIColor lightGrayColor];
    // Use this for block based notifications

    self.bottomSegmentedControl.titles = @[@"Left", @"Right"];
    self.bottomSegmentedControl.selectedTitleFont = [UIFont boldSystemFontOfSize:16];
    self.bottomSegmentedControl.unselectedTitleFont = [UIFont systemFontOfSize:16];
    self.bottomSegmentedControl.backgroundColor = [UIColor lightGrayColor];
    self.bottomSegmentedControl.didChangeSegmentBlock = ^(NSUInteger currentlySelectedIndex) {

        self.bottomLabel.text = [NSString stringWithFormat:@"Selected: %d", self.bottomSegmentedControl.currentlySelectedIndex];
    };

    self.topLabel.text = [NSString stringWithFormat:@"Selected: %d", self.topSegmentedControl.currentlySelectedIndex];
    self.bottomLabel.text = [NSString stringWithFormat:@"Selected: %d", self.bottomSegmentedControl.currentlySelectedIndex];
}

- (IBAction)topSegmentSelected:(id)sender {

    [self updateTopIndex];
}

- (IBAction)nextButtonPressed:(id)sender {

    NSUInteger nextIndex = self.topSegmentedControl.currentlySelectedIndex + 1;
    if ([self.topSegmentedControl isSegmentIndexValid:nextIndex]) {
        [self.topSegmentedControl setCurrentlySelectedIndex:nextIndex animated:YES];
        [self updateTopIndex];
    }
}
- (IBAction)prevButtonPressed:(id)sender {

    if (self.topSegmentedControl.currentlySelectedIndex > 0) {
        [self.topSegmentedControl setCurrentlySelectedIndex:self.topSegmentedControl.currentlySelectedIndex - 1 animated:YES];
        [self updateTopIndex];
    }
}

- (void)updateTopIndex {

    self.topLabel.text = [NSString stringWithFormat:@"Selected: %d", self.topSegmentedControl.currentlySelectedIndex];
}

@end
