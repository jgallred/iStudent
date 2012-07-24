//
//  DaysAndTimeViewController.h
//  TestUI
//
//  Created by Jason Allred on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimePickerViewController.h"
#import "DaysOfTheWeekPicker.h"

@class EditMeetingTimeViewController;

@protocol EditMeetingTimeViewControllerDelegate
@required
- (void) daysAndTime:(EditMeetingTimeViewController *)vc didFinishWithValues:(NSDictionary *)values;
- (void) daysAndTimeDidCancel:(EditMeetingTimeViewController *)vc;
@end

@interface EditMeetingTimeViewController : UITableViewController <DaysOfTheWeekPickerDelegate, TimePickerViewControllerDelegate>
{
    @private
    NSArray *sectionHeaders;
    NSArray *cellLabels;
    NSMutableDictionary *values;
    id<EditMeetingTimeViewControllerDelegate> delegate;
}

@property (assign) id<EditMeetingTimeViewControllerDelegate> delegate;
@property (retain, nonatomic) NSMutableDictionary *values;

@end
