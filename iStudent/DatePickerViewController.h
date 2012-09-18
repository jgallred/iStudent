//
//  DatePickerViewController.h
//  TestUI
//
//  Created by Jason Allred on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerViewController;

@protocol DatePickerViewControllerDelegate
@required
/*
 Notifies the delegate that the user finished making changes to the selected date
 */
- (void) datePicker:(DatePickerViewController *)vc didFinishWithDate:(NSDate *)date;
/*
 Notifies the delegate that the user canceled any changes
 */
- (void) datePickerDidCancel:(DatePickerViewController *)vc;
@end

@interface DatePickerViewController : UIViewController
{
    /* A date picker control */
    IBOutlet UIDatePicker *datePicker;
    /* Displays the current value of the date picker */
    IBOutlet UILabel *dateLabel;
    /* The view controller's delegate */
    id<DatePickerViewControllerDelegate> delegate;
    /* The date to edit */
    NSDate *date;
}

@property (assign) id<DatePickerViewControllerDelegate> delegate;
@property (retain, nonatomic) NSDate *date;

/*
 Updates the date label when the date picker value changes
 */
- (IBAction)datePickerChanged:(UIDatePicker *)sender;

@end
