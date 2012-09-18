//
//  CoursesViewController.m
//  iStudent
//
//  Created by Jason Allred on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoursesViewController.h"
#import "EditCourseViewController.h"
#import "NSManagedObject-IsNew.h"

@interface CoursesViewController ()
@property (retain) Semester *semester;
@end

@implementation CoursesViewController

@synthesize semester;

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context 
                        andSemester:(Semester *)aSemester
{
    if (self = [super initWithStyle:UITableViewStylePlain])
	{
        self.title = @"Courses";
        
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		request.entity = [NSEntityDescription entityForName:@"Course" 
                                     inManagedObjectContext:context];
        
        request.predicate = [NSPredicate predicateWithFormat:@"semester == %@", semester];
        
        request.sortDescriptors = [NSArray arrayWithObject:
                                   [NSSortDescriptor sortDescriptorWithKey:@"title" 
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
        self.semester = aSemester;
	}
	return self;
}

- (UIBarButtonItem *)makeAddButton
{
    return [[[UIBarButtonItem alloc] 
             initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
             target:self 
             action:@selector(addCourse:)] autorelease];
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

- (UITableViewCell *)tableView:(UITableView *)tableView 
          cellForManagedObject:(NSManagedObject *)managedObject 
{
    Course *course = (Course *)managedObject;
    static NSString *CellIdentifier = @"CourseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    cell.textLabel.text = course.title;
    
    return cell;
}

- (void)accessoryButtonTappedForManagedObject:(NSManagedObject *)managedObject
{
    [self editCourse:(Course *)managedObject];
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    //[self editSemester:(Semester *)managedObject];
}

/*
 Prepares a new Course instance for the semester and context provided in the initializer and 
 pushes a new view controller on the stack to edit it
 */
- (void)addCourse:(UIBarButtonItem *)button
{
    Course *course = [[NSEntityDescription 
                          insertNewObjectForEntityForName:@"Course"
                          inManagedObjectContext:
                           self.fetchedResultsController.managedObjectContext] autorelease];
    [self editCourse:course];
}

/*
 Presents an EditCourseViewController as a modal view controller to edit the course
 */
- (void)editCourse:(Course *)course
{
    EditCourseViewController *editCourse = [[[EditCourseViewController alloc] 
                                                 initWithCourse:course] autorelease];
    editCourse.delegate = self;
    UINavigationController *navCon = [[[UINavigationController alloc] 
                                       initWithRootViewController:editCourse] autorelease];
    [self presentModalViewController:navCon animated:YES];
}

- (void) editCourseViewController:(EditCourseViewController *)viewController 
              didCancelWithCourse:(Course *)course
{
    [self dismissModalViewControllerAnimated:YES];
    
    if ([course isNew]) {
        //TODO Destroys the instance?
        [course.managedObjectContext deleteObject:course];
        NSLog(@"Course is new.");
    } else {
        NSLog(@"Course is not new.");
        if([course hasChanges]) {
            [course.managedObjectContext rollback];
        }
    }
}

- (void) editCourseViewController:(EditCourseViewController *)viewController 
              didFinishWithCourse:(Course *)course
{
    NSError *error = nil;
    if(![course.managedObjectContext save:&error]) {
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

-(void)dealloc
{
    [semester release];
    [super dealloc];
}

@end
