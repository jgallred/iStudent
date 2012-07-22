//
//  SemestersViewController.m
//  iStudent
//
//  Created by Jason Allred on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SemestersViewController.h"
#import "EditSemesterViewController.h"
#import "NSManagedObject-IsNew.h"

@interface SemestersViewController ()

@end

@implementation SemestersViewController

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    if (self = [super initWithStyle:UITableViewStylePlain])
	{
        self.title = @"Semesters";
        
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		request.entity = [NSEntityDescription entityForName:@"Semester" 
                                     inManagedObjectContext:context];
        request.sortDescriptors = [NSArray arrayWithObject:
                                   [NSSortDescriptor sortDescriptorWithKey:@"startDate" 
                                                                 ascending:YES]];
		
		NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                           initWithFetchRequest:request
                                           managedObjectContext:context
                                           sectionNameKeyPath:nil
                                           cacheName:nil];
        
		[request release];
		
		self.fetchedResultsController = frc;
		[frc release];
		
		self.titleKey = @"title";
//        self.subtitleKey = @"subname";
//		self.searchKey = @"title";
	}
	return self;
}

- (UIBarButtonItem *)makeAddButton
{
    return [[[UIBarButtonItem alloc] 
             initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
             target:self 
             action:@selector(addSemester:)] autorelease];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [self makeAddButton];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addSemester:(UIBarButtonItem *)button
{
    Semester *semester = [[NSEntityDescription 
                          insertNewObjectForEntityForName:@"Semester"
                          inManagedObjectContext:
                           self.fetchedResultsController.managedObjectContext] autorelease];
    [self editSemester:semester];
}

- (void)editSemester:(Semester *)semester
{
    EditSemesterViewController *editSemester = [[[EditSemesterViewController alloc] 
                                                 initWithSemester:semester] autorelease];
    editSemester.delegate = self;
    UINavigationController *navCon = [[[UINavigationController alloc] 
                                       initWithRootViewController:editSemester] autorelease];
    [self presentModalViewController:navCon animated:YES];
}

- (void) editSemesterViewController:(EditSemesterViewController *)viewController
                       didCancelWithSemester:(Semester *)semester
{
    [self dismissModalViewControllerAnimated:YES];
    
    if ([semester isNew]) {
        [semester.managedObjectContext deleteObject:semester];
        NSLog(@"Semester is new.");
    } else {
        NSLog(@"Semester is not new.");
    }
}

- (void) editSemesterViewController:(EditSemesterViewController *)viewController didFinishWithSemester:(Semester *)semester
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
