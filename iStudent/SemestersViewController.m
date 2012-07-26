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
#import "CoursesViewController.h"

@interface SemestersViewController ()
@property (retain) NSManagedObjectContext *managedObjectContext;
@end

@implementation SemestersViewController

@synthesize managedObjectContext;

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
                                                                 ascending:NO]];
		
		NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                           initWithFetchRequest:request
                                           managedObjectContext:context
                                           sectionNameKeyPath:nil
                                           cacheName:nil];
        
		[request release];
		
		self.fetchedResultsController = frc;
		[frc release];
		
		self.titleKey = @"title";
        self.managedObjectContext = context;
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
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
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

- (NSString *) formatDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/yy"];
    return [df stringFromDate:date];
}

- (NSString *)detailTextForSemester:(Semester *)semester
{
    return [NSString stringWithFormat:@"%@ - %@", 
            [self formatDate:semester.startDate], 
            [self formatDate:semester.endDate]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
          cellForManagedObject:(NSManagedObject *)managedObject 
{
    Semester *semester = (Semester *)managedObject;
    static NSString *CellIdentifier = @"SemesterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    cell.textLabel.text = semester.title;
    cell.detailTextLabel.text = [self detailTextForSemester:semester];
    
    return cell;
}

- (void)accessoryButtonTappedForManagedObject:(NSManagedObject *)managedObject
{
    [self editSemester:(Semester *)managedObject];
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    CoursesViewController *courses = [[[CoursesViewController alloc] 
                                       initWithManagedObjectContext:self.managedObjectContext 
                                       andSemester:(Semester *)managedObject] autorelease];
    [self.navigationController pushViewController:courses animated:YES];
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
        //TODO Destroys the instance?
        [semester.managedObjectContext deleteObject:semester];
        NSLog(@"Semester is new.");
    } else {
        NSLog(@"Semester is not new.");
        if([semester hasChanges]) {
            [semester.managedObjectContext rollback];
        }
    }
}

- (void) editSemesterViewController:(EditSemesterViewController *)viewController didFinishWithSemester:(Semester *)semester
{
    NSError *error = nil;
    if(![semester.managedObjectContext save:&error]) {
        NSLog(@"Save Error");
        if(error != nil) {
            NSLog(@"Error: %@", error.description);
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)canDeleteManagedObject:(NSManagedObject *)managedObject
{
    return YES;
}

- (void)deleteManagedObject:(NSManagedObject *)managedObject
{
    [managedObject.managedObjectContext deleteObject:managedObject];
    NSError *error = nil;
    if(![managedObject.managedObjectContext save:&error]) {
        NSLog(@"Delete Error");
        if(error != nil) {
            NSLog(@"Error: %@", error.description);
        }
    }
}

@end
