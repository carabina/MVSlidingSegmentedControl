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

@property(strong, nonatomic) IBOutlet MVSlidingSegmentedControl *middleSegmentedControl;
@property(strong, nonatomic) IBOutlet UILabel *middleLabel;

@end

@implementation ViewController

- (void)configureSegmentedControl:(MVSlidingSegmentedControl *)control fontSize:(CGFloat)fontSize {
    control.selectedTitleFont = [UIFont boldSystemFontOfSize:fontSize];
    control.unselectedTitleFont = [UIFont systemFontOfSize:fontSize];
    control.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    __weak typeof(self) weakSelf = self;

    self.topSegmentedControl.titles = @[@"Left", @"Center", @"Right"];
    [self configureSegmentedControl:self.topSegmentedControl fontSize:16];
    self.topSegmentedControl.cornerRadius = 10;

    self.middleSegmentedControl.titles = @[@"Left", @"Center 1", @"Center 2", @"Right"];
    [self configureSegmentedControl:self.middleSegmentedControl fontSize:14];
    self.middleSegmentedControl.cornerRadius = 5;
    self.middleSegmentedControl.didChangeSegmentBlock = ^(NSUInteger selectedSegmentIndex) {

        weakSelf.middleLabel.text = [NSString stringWithFormat:@"Selected: %d", selectedSegmentIndex];
    };
    
    self.topLabel.text = [NSString stringWithFormat:@"Selected: %d", self.topSegmentedControl.selectedSegmentIndex];
    self.middleLabel.text = [NSString stringWithFormat:@"Selected: %d", self.middleSegmentedControl.selectedSegmentIndex];
    self.bottomLabel.text = [NSString stringWithFormat:@"Selected: %d", self.bottomSegmentedControl.selectedSegmentIndex];

    self.bottomSegmentedControl.titles = @[@"Left", @"Right"];
    [self configureSegmentedControl:self.bottomSegmentedControl fontSize:16];
    self.bottomSegmentedControl.cornerRadius = 7.5;
    self.bottomSegmentedControl.didChangeSegmentBlock = ^(NSUInteger selectedSegmentIndex) {

        weakSelf.bottomLabel.text = [NSString stringWithFormat:@"Selected: %d", selectedSegmentIndex];
    };

    self.topLabel.text = [NSString stringWithFormat:@"Selected: %d", self.topSegmentedControl.selectedSegmentIndex];
    self.bottomLabel.text = [NSString stringWithFormat:@"Selected: %d", self.bottomSegmentedControl.selectedSegmentIndex];
}

- (IBAction)topSegmentSelected:(id)sender {

    [self updateTopIndex];
}

- (IBAction)nextButtonPressed:(id)sender {

    NSUInteger nextIndex = self.topSegmentedControl.selectedSegmentIndex + 1;
    if ([self.topSegmentedControl isSegmentIndexValid:nextIndex]) {
        [self.topSegmentedControl setSelectedSegmentIndex:nextIndex animated:YES];
        [self updateTopIndex];
    }
}
- (IBAction)prevButtonPressed:(id)sender {

    if (self.topSegmentedControl.selectedSegmentIndex > 0) {
        [self.topSegmentedControl setSelectedSegmentIndex:self.topSegmentedControl.selectedSegmentIndex - 1 animated:YES];
        [self updateTopIndex];
    }
}

- (void)updateTopIndex {

    self.topLabel.text = [NSString stringWithFormat:@"Selected: %d", self.topSegmentedControl.selectedSegmentIndex];
}

@end
