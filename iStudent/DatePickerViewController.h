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
- (void) datePicker:(DatePickerViewController *)vc didFinishWithDate:(NSDate *)date;
- (void) datePickerDidCancel:(DatePickerViewController *)vc;
@end

@interface DatePickerViewController : UIViewController
{
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UILabel *dateLabel;
    id<DatePickerViewControllerDelegate> delegate;
    NSDate *date;
}

@property (assign) id<DatePickerViewControllerDelegate> delegate;
@property (retain, nonatomic) NSDate *date;

- (IBAction)datePickerChanged:(UIDatePicker *)sender;

@end
