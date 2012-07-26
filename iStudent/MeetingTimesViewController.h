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

@interface MeetingTimesViewController : CoreDataTableViewController <EditMeetingTimeViewControllerDelegate>
{
    Course *course;
}

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context 
                          andCourse:(Course *)aCourse;
@end
