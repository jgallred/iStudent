//
//  Course.h
//  iStudent
//
//  Created by Jason Allred on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Semester;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * instructor;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) Semester *semester;
@property (nonatomic, retain) NSSet *meetingTimes;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addMeetingTimesObject:(NSManagedObject *)value;
- (void)removeMeetingTimesObject:(NSManagedObject *)value;
- (void)addMeetingTimes:(NSSet *)values;
- (void)removeMeetingTimes:(NSSet *)values;

@end
