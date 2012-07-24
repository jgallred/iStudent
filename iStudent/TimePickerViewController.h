//
//  TimeViewController.h
//  TestUI
//
//  Created by Jason Allred on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaysOfTheWeekPicker.h"

@class TimePickerViewController;

@protocol TimePickerViewControllerDelegate
@required
- (void) timePicker:(TimePickerViewController *)vc didFinshWithTime:(NSDate *)date;
- (void) timePickerDidCancel:(TimePickerViewController *)vc;
@end

@interface TimePickerViewController : UIViewController
{
    id<TimePickerViewControllerDelegate> delegate;
    IBOutlet UIDatePicker *timePicker;
    IBOutlet UILabel *timeLabel;
    NSDate *time;
}
@property (assign) id<TimePickerViewControllerDelegate> delegate;
@property (retain, nonatomic) NSDate *time;

- (void)donePressed:(UIBarButtonItem *)sender;
- (IBAction)timeChanged:(UIDatePicker *)sender;

@end
