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
/*
 Notifies the delegate that the user finished making changes to the meeting time
 */
- (void) editMeetingTimeViewController:(EditMeetingTimeViewController *)vc 
                   didFinishWithMeetingTime:(MeetingTime *)meetingTime;

@optional
/* 
 Notifies the delegate that the user canceled any changes to the meeting time
 */
- (void) editMeetingTimeViewController:(EditMeetingTimeViewController *)vc
              didCancelWithMeetingTime:(MeetingTime *)meetingTime;
@end

/*
 View Controller for editing a course meeting time
 */
@interface EditMeetingTimeViewController : UITableViewController <DaysOfTheWeekPickerDelegate, TimePickerViewControllerDelegate>
{
    @private
    /* An array of NSStrings for table section headers */
    NSArray *sectionHeaders;
    /* An array of NSStrings for table cell labels */
    NSArray *cellLabels;
    /* The MeetingTime instance represented by this view controller */
    MeetingTime *meetingTime;
    
    /* The view controller's delegate */
    id<EditMeetingTimeViewControllerDelegate> delegate;
}

@property (assign) id<EditMeetingTimeViewControllerDelegate> delegate;

/*
 Initializes the view controller with the specified meeting time
 */
-(id)initWithMeetingTime:(MeetingTime *)aMeetingTime;

@end
