//
//  TapViewController.m
//  Test Suite
//
//  Created by Brian Nickel on 6/26/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIPickerViewAccessibilityDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *memoryWarningLabel;
@property (weak, nonatomic) IBOutlet UITextField *otherTextField;
@property (weak, nonatomic) IBOutlet UITextField *greetingTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;

@end

@implementation TapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}

- (void)viewWillAppear:(BOOL)animated {
    CGRect buttonContainerFrame = self.buttonContainerView.frame;
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(buttonContainerFrame), CGRectGetMaxY(buttonContainerFrame));
}

- (void)memoryWarningNotification:(NSNotification *)notification
{
    self.memoryWarningLabel.hidden = NO;
}

- (IBAction)hideMemoryWarning
{
    self.memoryWarningLabel.hidden = YES;
}

- (IBAction)toggleSelected:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.slider.value = self.slider.value + 1;
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.slider.value = self.slider.value - 1;
    });
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    sender.accessibilityValue = [NSString stringWithFormat:@"%d", (int)roundf(sender.value)];
}

- (IBAction)pickPhoto:(id)sender
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [@[@"Alpha", @"Bravo", @"Charlie"] objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView accessibilityLabelForComponent:(NSInteger)component
{
    return @"Call Sign";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.otherTextField) {
        [self.greetingTextField becomeFirstResponder];
    }
    return NO;
}

@end
