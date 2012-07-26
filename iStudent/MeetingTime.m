//
//  MeetingTime.m
//  iStudent
//
//  Created by Jason Allred on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeetingTime.h"
#import "Course.h"


@implementation MeetingTime

@dynamic daysOfWeek;
@dynamic startTime;
@dynamic endTime;
@dynamic course;

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    self.startTime = [NSDate date];
    self.endTime = [NSDate dateWithTimeIntervalSinceNow:60*60];
}

+ (NSString *)stringForDaysOfMeetingTime:(MeetingTime *)meetingTime
{
    NSMutableString *dayString = [NSMutableString string];
    int daysInt = [meetingTime.daysOfWeek intValue];
    if (daysInt & MeetingTimeSunday) {
        [dayString appendString:@"Su"];
    } 
    if (daysInt & MeetingTimeMonday) {
        [dayString appendString:@"M"];
    } 
    if (daysInt & MeetingTimeTuesday) {
        [dayString appendString:@"Tu"];
    } 
    if (daysInt & MeetingTimeWednesday) {
        [dayString appendString:@"W"];
    } 
    if (daysInt & MeetingTimeThursday) {
        [dayString appendString:@"Th"];
    } 
    if (daysInt & MeetingTimeFriday) {
        [dayString appendString:@"F"];
    } 
    if (daysInt & MeetingTimeSaturday) {
        [dayString appendString:@"Sa"];
    }
    return dayString;
}

@end
