//
//  MeetingTimesViewController.m
//  iStudent
//
//  Created by Jason Allred on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeetingTimesViewController.h"
#import "MeetingTime.h"
#import "NSManagedObject-IsNew.h"

@interface MeetingTimesViewController ()
@property (retain) Course *course;
@end

@implementation MeetingTimesViewController

@synthesize course;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context 
                       andCourse:(Course *)aCourse
{
    if (self = [super initWithStyle:UITableViewStylePlain])
	{
        self.title = @"Class Times";
        
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		request.entity = [NSEntityDescription entityForName:@"MeetingTime" 
                                     inManagedObjectContext:context];
        
        request.predicate = [NSPredicate predicateWithFormat:@"course == %@", aCourse];
        
        request.sortDescriptors = [NSArray arrayWithObject:
                                   [NSSortDescriptor sortDescriptorWithKey:@"startTime" 
                                                                 ascending:YES]];
		
		NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                           initWithFetchRequest:request
                                           managedObjectContext:context
                                           sectionNameKeyPath:nil
                                           cacheName:nil];
        
		[request release];
		
		self.fetchedResultsController = frc;
		[frc release];
		
		self.titleKey = @"startTime";
        self.course = aCourse;
	}
	return self;
}

- (UIBarButtonItem *)makeAddButton
{
    return [[[UIBarButtonItem alloc] 
             initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
             target:self 
             action:@selector(addMeetingTime:)] autorelease];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [self makeAddButton];
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

/*
 Sets the text label of the cell based on the meeting time
 */
-(void)setTitleOfCell:(UITableViewCell *)cell withMeetingTime:(MeetingTime *)meetingTime
{
    cell.textLabel.text = [MeetingTime stringForDaysOfMeetingTime:meetingTime];
}

/*
 Generates an NSString from the provided NSDate
 */
-(NSString *)stringForTime:(NSDate *)time
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle]; 
    return [df stringFromDate:time];
}

/*
 Generates a string of the times for the meeting time, formatted "startTime - endTime"
 */
-(NSString *)stringForMeetingTime:(MeetingTime *)meetingTime
{
    return [NSString stringWithFormat:@"%@ - %@",
            [self stringForTime:meetingTime.startTime],
            [self stringForTime:meetingTime.endTime]];
}

/*
 Sets the detail label of the cell with the time range string for the meeting time
 */
-(void)setDetailOfCell:(UITableViewCell *)cell withMeetingTime:(MeetingTime *)meetingTime
{
    cell.detailTextLabel.text = [self stringForMeetingTime:meetingTime];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
          cellForManagedObject:(NSManagedObject *)managedObject 
{
    MeetingTime *meetingTime = (MeetingTime *)managedObject;
    static NSString *CellIdentifier = @"MeetingTimeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self setTitleOfCell:cell withMeetingTime:meetingTime];
    [self setDetailOfCell:cell withMeetingTime:meetingTime];
    
    return cell;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    [self editMeetingTime:(MeetingTime *)managedObject];
}

/*
 Prepares a new MeetingTime instance for the course and context provided in the initializer and
 pushes a new view controller on the stack to edit it
 */
- (void)addMeetingTime:(UIBarButtonItem *)button
{
    MeetingTime *meetingTime = [[NSEntityDescription 
                       insertNewObjectForEntityForName:@"MeetingTime"
                       inManagedObjectContext:
                       self.fetchedResultsController.managedObjectContext] autorelease];
    meetingTime.course = self.course;
    [self editMeetingTime:meetingTime];
}

/*
 Presents an EditMeetingTimeViewController as a modal view controller to edit the meeting time
 */
- (void)editMeetingTime:(MeetingTime *)meetingTime
{
    EditMeetingTimeViewController *editTime = [[[EditMeetingTimeViewController alloc] 
                                             initWithMeetingTime:meetingTime] autorelease];
    editTime.delegate = self;
    UINavigationController *navCon = [[[UINavigationController alloc] 
                                       initWithRootViewController:editTime] autorelease];
    [self presentModalViewController:navCon animated:YES];
}

-(void)editMeetingTimeViewController:(EditMeetingTimeViewController *)vc 
            didCancelWithMeetingTime:(MeetingTime *)meetingTime
{
    [self dismissModalViewControllerAnimated:YES];
    if ([meetingTime isNew]) {
        //TODO Destroys the instance?
        [meetingTime.managedObjectContext deleteObject:meetingTime];
        NSLog(@"meetingTime is new.");
    } else {
        NSLog(@"meetingTime is not new.");
        if([meetingTime hasChanges]) {
            [meetingTime.managedObjectContext rollback];
        }
    }
}

-(void)editMeetingTimeViewController:(EditMeetingTimeViewController *)vc 
            didFinishWithMeetingTime:(MeetingTime *)meetingTime
{
    NSError *error = nil;
    if(![meetingTime.managedObjectContext save:&error]) {
        NSLog(@"Save Error");
        if(error != nil) {
            NSLog(@"Error: %@", error.description);
        }
    }
    [self dismissModalViewControllerAnimated:YES];
    
    [self setTitleOfCell:[self selectedCell] withMeetingTime:meetingTime];
    [self setDetailOfCell:[self selectedCell] withMeetingTime:meetingTime];
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
