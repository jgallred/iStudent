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

@interface CoursesViewController : CoreDataTableViewController <EditCourseViewControllerDelegate>
{
    Semester *semester;
}

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context 
                       andSemester:(Semester *)aSemester;
@end
