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
/*
 Notifies the delegate that the user finished making changes to the selected time
 */
- (void) timePicker:(TimePickerViewController *)vc didFinshWithTime:(NSDate *)date;
/*
 Notifies the delegate that the user canceled any changes
 */
- (void) timePickerDidCancel:(TimePickerViewController *)vc;
@end

/*
 A view controller for editing a time
 */
@interface TimePickerViewController : UIViewController
{
    /* The view controller's delegate */
    id<TimePickerViewControllerDelegate> delegate;
    
    /* A time picker control */
    IBOutlet UIDatePicker *timePicker;
    /* Displays the date string based on the time picker */
    IBOutlet UILabel *timeLabel;
    /* The time represented by this view controller */
    NSDate *time;
}
@property (assign) id<TimePickerViewControllerDelegate> delegate;
@property (retain, nonatomic) NSDate *time;

- (void)donePressed:(UIBarButtonItem *)sender;
- (IBAction)timeChanged:(UIDatePicker *)sender;

@end
