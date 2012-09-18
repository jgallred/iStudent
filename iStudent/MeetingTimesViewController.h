//
//  MeetingTimesViewController.h
//  iStudent
//
//  Created by Jason Allred on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Course.h"
#import "EditMeetingTimeViewController.h"

/*
 Displays a list of meeting times for a given course
 */
@interface MeetingTimesViewController : CoreDataTableViewController <EditMeetingTimeViewControllerDelegate>
{
    /* The course whose meeting times should be displayed */ 
    Course *course;
}

/*
 Initializes the view controller to save meeting times for the course with the specifed context
 */
- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context 
                          andCourse:(Course *)aCourse;
@end
