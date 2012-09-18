//
//  CoursesViewController.h
//  iStudent
//
//  Created by Jason Allred on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "EditCourseViewController.h"
#import "Semester.h"

/*
 Displays a list of courses for a given semester
 */
@interface CoursesViewController : CoreDataTableViewController <EditCourseViewControllerDelegate>
{
    /* The semester to display courses for */
    Semester *semester;
}

/*
 Initializes the view controller to save courses for the semester with the specifed context
 */
- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context 
                       andSemester:(Semester *)aSemester;
@end
