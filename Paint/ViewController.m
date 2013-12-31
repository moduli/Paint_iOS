//
//  ViewController.m
//  Paint
//
//  Created by Michael Li on 12/22/13.
//  Copyright (c) 2013 Michael Li. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

#pragma mark - System Events

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // INITIAL SETTINGS
    // rgb is initially set to black
    red = 0.0;
    green = 0.0;
    blue = 0.0;
    
    brush = 10.0;
    opacity = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SettingsViewController* settingsVC = (SettingsViewController *)segue.destinationViewController;
    settingsVC.delegate = self; // set delegate as self
    
    settingsVC.brush = brush; // set settings value to current value
    settingsVC.opacity = opacity; // set settings value to current value
    settingsVC.red = red;
    settingsVC.green = green;
    settingsVC.blue = blue;
}

#pragma mark - SettingsViewControllerDelegate

- (void)closeSettings:(id)sender {
    // save new values
    brush = ((SettingsViewController*)sender).brush;
    opacity = ((SettingsViewController*)sender).opacity;
    red = ((SettingsViewController*)sender).red;
    green = ((SettingsViewController*)sender).green;
    blue = ((SettingsViewController*)sender).blue;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - User Actions

- (IBAction)pencilPressed:(id)sender {
    eraser = NO;
    /*
    UIButton* pressedButton = (UIButton*)sender;
    
    // tags are set in the Attributes inspector of an object
    switch(pressedButton.tag) {
        case 0: // black
            red = 0.0;
            green = 0.0;
            blue = 0.0;
            break;
        case 1: // blue
            red = 0.0;
            green = 0.0;
            blue = 255.0;
            break;
    }
    */
}

- (IBAction)eraserPressed:(id)sender {
    // set colors to "white"
    //red = 255.0;
    //green = 255.0;
    //blue = 255.0;
    //opacity = 1.0;
    
    eraser = YES;
}

- (IBAction)reset:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:@"Reset canvas?", nil];
    [actionSheet setTag:1];
    [actionSheet showInView:self.view];
}

- (IBAction)save:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:@"Save to Camera Roll", nil];
    [actionSheet setTag:0];
    [actionSheet showInView:self.view];
}


- (IBAction)settings:(id)sender {
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // SAVE DIALOG
    if ([actionSheet tag] == 0) {
        if (buttonIndex == 0) {
            // define an image context
            UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO,0.0);
            [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
            
            // grab image from mainImage
            UIImage* SaveImage = UIGraphicsGetImageFromCurrentImageContext();
            
            // end
            UIGraphicsEndImageContext();
            
            // save image to camera roll
            UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
            
        }
    }
    // RESET DIALOG
    else if ([actionSheet tag] == 1) {
        // if first button (OK)
        if (buttonIndex == 0) {
            // clear mainImage
            self.mainImage.image = nil;
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photoalbum"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}


#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = NO;
    
    // get and store current point
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = YES;
    
    // get current point
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    // drawing setup
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    // (starting point) - x,y relative to begin image context
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    // (ending point)
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    // line properties
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
    if (eraser) {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);
    }
    else {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red/255.0, green/255.0, blue/255.0, 1.0);
    }
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    // create the line
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    // put created line onto tempDrawImage
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    if (eraser) {
        [self.tempDrawImage setAlpha:1.0];
    }
    else {
        [self.tempDrawImage setAlpha:opacity];
    }
    
    // end drawing
    UIGraphicsEndImageContext();

    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // if user did not drag, then draw the single touch point
    if(!mouseSwiped) {
        // drawing setup (create a context of this size)
        UIGraphicsBeginImageContext(self.view.frame.size);
        
        // put user's drawing into the context
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        // define line properties
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        if (eraser) {
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);
        }
        else {
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red/255.0, green/255.0, blue/255.0, opacity);
        }
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        
        // create line
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        
        // put context onto tempdrawimage
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        
        // end drawing
        UIGraphicsEndImageContext();
    }
    
    // MERGE TEMPDRAWIMAGE WITH MAINIMAGE and CLEAR TEMPDRAWIMAGE
    // drawing setup
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    
    // put existing drawings into the context
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    // put new drawing into the context
    if (eraser) {
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    }
    else {
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    }
    // draw context onto mainimage
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // clear tempdrawimage
    self.tempDrawImage.image = nil;
    
    // end drawing
    UIGraphicsEndImageContext();
}

@end
