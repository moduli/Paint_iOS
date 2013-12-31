//
//  SettingsViewController.h
//  Paint
//
//  Created by Michael Li on 12/28/13.
//  Copyright (c) 2013 Michael Li. All rights reserved.
//

#import <UIKit/UIKit.h>

// force invoker to define delegate for dismissing the window
@protocol SettingsViewControllerDelegate <NSObject>
- (void)closeSettings: (id)sender;
@end


@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *preview;
@property (weak, nonatomic) IBOutlet UISlider *brushControl;
@property (weak, nonatomic) IBOutlet UILabel *brushValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *opacityControl;
@property (weak, nonatomic) IBOutlet UILabel *opacityValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *redControl;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UISlider *greenControl;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UISlider *blueControl;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;

@property CGFloat brush;
@property CGFloat opacity;
@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;

- (IBAction)sliderChanged:(id)sender;
- (IBAction)closeSettings:(id)sender;

@end
