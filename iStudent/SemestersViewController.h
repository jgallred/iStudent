//
//  SemestersViewController.h
//  iStudent
//
//  Created by Jason Allred on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "EditSemesterViewController.h"

/*
 Displays a list of semesters belonging to the user
 */
@interface SemestersViewController : CoreDataTableViewController <EditSemesterViewControllerDelegate>
{
    /* The context in which to save NSManagedObjects */
    NSManagedObjectContext *managedObjectContext;
}

/* Initializes the view controller with the specified context */
- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context;
@end
