//
//  DaysTableViewController.h
//  TestUI
//
//  Created by Jason Allred on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DaysOfTheWeekPicker;

@protocol DaysOfTheWeekPickerDelegate
@required
/*
 Notifies the delegate that the user finished making changes to the selected days of the week
 */
- (void) daysOfTheWeekPicker:(DaysOfTheWeekPicker *)vc didFinishWithDays:(NSArray *)days;
/*
 Notifies the delegate that the user canceled any changes
 */
- (void) daysOfTheWeekPickerDidCancel:(DaysOfTheWeekPicker *)vc;
@end

/*
 A view controller for selecting days of the week
 */
@interface DaysOfTheWeekPicker : UITableViewController
{
    @private
    /* The view controller's delegate */
    id<DaysOfTheWeekPickerDelegate> delegate;
    
    /* An array of booleans representing whether a day has been selected */
    NSMutableArray *daysOfWeek;
    /* An array of NSStrings for the cell labels for the days of the week */
    NSArray *daysOfWeekTitles;
    /**/
    NSArray *resultDays;
    /* 
     An array of NSNumbers specifying which days to display selected when the view controller
     initializes
     */
    NSArray *selectedDays;
}

enum DaysOfTheWeekDays {
    DaysOfTheWeekSunday,
    DaysOfTheWeekMonday,
    DaysOfTheWeekTuesday,
    DaysOfTheWeekWednesday,
    DaysOfTheWeekThursday,
    DaysOfTheWeekFriday,
    DaysOfTheWeekSaturday
};

@property (assign) id<DaysOfTheWeekPickerDelegate> delegate;
@property (retain, nonatomic) NSArray *selectedDays;

@end
