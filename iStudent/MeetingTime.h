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
    MeetingTimeSunday = 0x01, //0000 0001
    MeetingTimeMonday = 0x02, //0000 0010
    MeetingTimeTuesday = 0x04, //0000 0100
    MeetingTimeWednesday = 0x08, //0000 1000
    MeetingTimeThursday = 0x10, //0001 0000
    MeetingTimeFriday = 0x20, //0010 0000
    MeetingTimeSaturday = 0x40 //0100 0000
};

+ (NSString *)stringForDaysOfMeetingTime:(MeetingTime *)meetingTime;

@end
