//
//  ViewController.h
//  Paint
//
//  Created by Michael Li on 12/22/13.
//  Copyright (c) 2013 Michael Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h" // get definition of settingsviewcontrollerdelegate

// definition of viewcontroller
// also implements settingsviewcontrollerdelegate
@interface ViewController : UIViewController <SettingsViewControllerDelegate, UIActionSheetDelegate> {
    CGPoint lastPoint; // stores last drawn point on the canvas. used when a continuous brush stroke is being drawn on the canvas
    CGFloat red; // current R value (RGB)
    CGFloat green; // current G value (RGB)
    CGFloat blue; // current B value (RGB)
    CGFloat brush; // brush stroke width
    CGFloat opacity; // opacity value
    
    BOOL mouseSwiped; // identifies if the brush stroke is continuous
    BOOL eraser;
}


@property (weak, nonatomic) IBOutlet UIImageView *mainImage; // stores user's drawing
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage; // stores user's newest addition to the drawing. merged with mainImage each time.



- (IBAction)pencilPressed:(id)sender;
- (IBAction)eraserPressed:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)settings:(id)sender;

@end
