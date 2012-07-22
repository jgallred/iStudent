//
//  SemestersViewController.h
//  iStudent
//
//  Created by Jason Allred on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "EditSemesterViewController.h"

@interface SemestersViewController : CoreDataTableViewController <EditSemesterViewControllerDelegate>

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context;
@end
