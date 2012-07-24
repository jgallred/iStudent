//
//  MeetingTime.h
//  iStudent
//
//  Created by Jason Allred on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface MeetingTime : NSManagedObject

@property (nonatomic, retain) NSNumber * daysOfWeek;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) Course *course;

enum MeetingTimeDays {
    MeetingTimeSunday = 1,
    MeetingTimeMonday = 2,
    MeetingTimeTuesday = 4,
    MeetingTimeWednesday = 8,
    MeetingTimeThursday = 16,
    MeetingTimeFriday = 32,
    MeetingTimeSaturday = 64
};

@end
