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
- (void) daysOfTheWeekPicker:(DaysOfTheWeekPicker *)vc didFinishWithDays:(NSArray *)days;
- (void) daysOfTheWeekPickerDidCancel:(DaysOfTheWeekPicker *)vc;
@end

@interface DaysOfTheWeekPicker : UITableViewController
{
    @private
    id<DaysOfTheWeekPickerDelegate> delegate;
    NSMutableArray *daysOfWeek;
    NSArray *daysOfWeekTitles;
    NSArray *resultDays;
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
