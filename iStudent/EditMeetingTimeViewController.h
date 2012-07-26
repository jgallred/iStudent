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
#import "MeetingTime.h"

@class EditMeetingTimeViewController;

@protocol EditMeetingTimeViewControllerDelegate
@required
- (void) editMeetingTimeViewController:(EditMeetingTimeViewController *)vc 
                   didFinishWithMeetingTime:(MeetingTime *)meetingTime;

@optional
- (void) editMeetingTimeViewController:(EditMeetingTimeViewController *)vc
              didCancelWithMeetingTime:(MeetingTime *)meetingTime;
@end

@interface EditMeetingTimeViewController : UITableViewController <DaysOfTheWeekPickerDelegate, TimePickerViewControllerDelegate>
{
    @private
    NSArray *sectionHeaders;
    NSArray *cellLabels;
    MeetingTime *meetingTime;
    id<EditMeetingTimeViewControllerDelegate> delegate;
}

@property (assign) id<EditMeetingTimeViewControllerDelegate> delegate;

-(id)initWithMeetingTime:(MeetingTime *)aMeetingTime;

@end
