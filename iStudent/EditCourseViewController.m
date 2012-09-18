//
//  EditCourseViewController.m
//  iStudent
//
//  Created by Jason Allred on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditCourseViewController.h"
#import "MeetingTimesViewController.h"

@interface EditCourseViewController ()
@property (readonly) NSArray *cellLabels;
@property (readonly) NSArray *sectionLabels;
@property (retain) Course *course;
@end

@implementation EditCourseViewController

@synthesize course;
@synthesize delegate;

#define TITLE_CELL @"Title"
#define INSTRUCTOR_CELL @"Instructor"
#define LOCATION_CELL @"Location"
#define MEETING_TIME_CELL @"Meeting Times"

- (NSArray *)cellLabels
{
    if (!cellLabels) {
        cellLabels = [[NSArray arrayWithObjects:
                       [NSArray arrayWithObject:TITLE_CELL],
                       [NSArray arrayWithObject:MEETING_TIME_CELL],
                       [NSArray arrayWithObjects:
                        INSTRUCTOR_CELL, 
                        LOCATION_CELL, nil], nil] retain];
    }
    return cellLabels;
}

- (NSArray *)sectionLabels
{
    if (!sectionLabels) {
        sectionLabels = [[NSArray arrayWithObjects:@"", @"", @"Details", nil] retain];
    }
    return sectionLabels;
}

-(id)initWithCourse:(Course *)aCourse
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.course = aCourse;
        self.title = (self.course.title.length > 0) ? self.course.title : @"New Course";
    }
    return self; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = 
    [[[UIBarButtonItem alloc] initWithTitle:@"Done" 
                                      style:UIBarButtonItemStyleDone 
                                     target:self 
                                     action:@selector(donePressed:)] autorelease];
    
    self.navigationItem.leftBarButtonItem = 
    [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
                                      style:UIBarButtonItemStylePlain 
                                     target:self 
                                     action:@selector(cancelPressed:)] autorelease];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellLabels.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionLabels objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)[self.cellLabels objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CourseEditCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.cellLabels objectAtIndex:indexPath.section] 
                           objectAtIndex:indexPath.row];
    
    [self setValueOfCell:cell];
    
    return cell;
}

/*
 Sets the detail label of the cell with the correct data based on the cell label
 */
- (void)setValueOfCell:(UITableViewCell *)cell
{
    NSString *cellLabel = cell.textLabel.text;
    if([cellLabel isEqualToString:TITLE_CELL]) {
        cell.detailTextLabel.text = self.course.title;
    } else if([cellLabel isEqualToString:INSTRUCTOR_CELL]) {
        cell.detailTextLabel.text = self.course.instructor;
    } else if([cellLabel isEqualToString:LOCATION_CELL]) {
        cell.detailTextLabel.text = self.course.location;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellLabel = [[self.cellLabels objectAtIndex:indexPath.section] 
                           objectAtIndex:indexPath.row];
    
    if([cellLabel isEqualToString:TITLE_CELL]) {
        [self getTextWithTitle:cellLabel andText:self.course.title andPlaceholder:@"Course Title"];
    } else if ([cellLabel isEqualToString:INSTRUCTOR_CELL]) {
        [self getTextWithTitle:cellLabel andText:self.course.instructor andPlaceholder:@"Name"];
    }  else if ([cellLabel isEqualToString:LOCATION_CELL]) {
        [self getTextWithTitle:cellLabel andText:self.course.location andPlaceholder:@"Where"];
    }  else if ([cellLabel isEqualToString:MEETING_TIME_CELL]) {
        MeetingTimesViewController *meetings = 
        [[[MeetingTimesViewController alloc] 
          initWithManagedObjectContext:self.course.managedObjectContext 
          andCourse:self.course] autorelease];
        [self.navigationController pushViewController:meetings animated:YES];
    }
}

/* 
 Pushes a new TextEntryViewController onto the navigation stack with the given title, existing
 text, and placeholder 
 */
- (void)getTextWithTitle:(NSString *)title 
                 andText:(NSString *)text 
          andPlaceholder:(NSString *)placeholder
{
    TextEntryViewController *textEntry = [[[TextEntryViewController alloc] init] autorelease];
    textEntry.title = title;
    textEntry.text = text;
    textEntry.delegate = self;
    textEntry.placeholder = placeholder;
    [self.navigationController pushViewController:textEntry animated:YES];
}

/*
 Returns the selected table cell
 */
- (UITableViewCell *)selectedCell
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    return [self.tableView cellForRowAtIndexPath:path];
}

- (void) textEntry:(TextEntryViewController *)viewController didFinishWithText:(NSString *)text
{
    [self selectedCell].detailTextLabel.text = text;
    
    if([viewController.title isEqualToString:TITLE_CELL]) {
        self.course.title = text;
    } else if ([viewController.title isEqualToString:INSTRUCTOR_CELL]) {
        self.course.instructor = text;
    }  else if ([viewController.title isEqualToString:LOCATION_CELL]) {
        self.course.location = text;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) textEntrydidCancel:(TextEntryViewController *)viewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)donePressed:(UIBarButtonItem *)sender
{
    [self.delegate editCourseViewController:self didFinishWithCourse:self.course];
}

- (void) cancelPressed:(UIBarButtonItem *)sender
{
    [self.delegate editCourseViewController:self didCancelWithCourse:self.course];
}

- (void) dealloc
{
    //TODO [course release];
    [cellLabels release];
    [super dealloc];
}

@end
