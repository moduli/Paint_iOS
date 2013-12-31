//
//  SettingsViewController.m
//  Paint
//
//  Created by Michael Li on 12/28/13.
//  Copyright (c) 2013 Michael Li. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

# pragma mark - System Events

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // take value sent viewcontroller
    self.brushControl.value = self.brush;
    self.opacityControl.value = self.opacity;
    self.redControl.value = self.red;
    self.greenControl.value = self.green;
    self.blueControl.value = self.blue;
    
    [self setControls];
    //[self setOpacityControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - User Events

- (IBAction)closeSettings:(id)sender {
    // this will instead be called by the delegate
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    // call delegate function
    [self.delegate closeSettings:self];
}

- (IBAction)sliderChanged:(id)sender {
    //UISlider* changedSlider = (UISlider*) sender;

    [self setControls];
    
    /*
    // BRUSH SIZE
    if(changedSlider == self.brushControl) {
        [self setBrushControls];
        
    }
    // OPACITY
    else if(changedSlider == self.opacityControl) {
        [self setOpacityControls];
    }
     */
}

- (void) setControls {
    self.brush = self.brushControl.value;
    self.brushValueLabel.text = [NSString stringWithFormat:@"%.1f", self.brush];
    
    self.opacity = self.opacityControl.value;
    self.opacityValueLabel.text = [NSString stringWithFormat:@"%.1f", self.opacity];
    
    self.red = self.redControl.value;
    self.green = self.greenControl.value;
    self.blue = self.blueControl.value;
    self.redLabel.text = [NSString stringWithFormat:@"%.0f", self.red];
    self.greenLabel.text = [NSString stringWithFormat:@"%.0f", self.green];
    self.blueLabel.text = [NSString stringWithFormat:@"%.0f", self.blue];
    
    // start a drawing
    UIGraphicsBeginImageContext(self.preview.frame.size);
    
    // set line properties
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red/255.0, self.green/255.0, self.blue/255.0, self.opacity);
    
    // define "line" path
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 40, 40);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 40, 40);
    
    // draw line
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.preview.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // end drawing
    UIGraphicsEndImageContext();
}
/*
- (void) setOpacityControls {
    // save current value
    self.opacity = self.opacityControl.value;
    
    // set label
    self.opacityValueLabel.text = [NSString stringWithFormat:@"%.1f", self.opacity];
    
    // start a drawing
    UIGraphicsBeginImageContext(self.opacityPreview.frame.size);
    
    // set line properties
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, self.opacity);
    
    // define line path
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),40, 40);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),40, 40);
    
    // draw line
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.opacityPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // end drawing
    UIGraphicsEndImageContext();
}
 */
@end
