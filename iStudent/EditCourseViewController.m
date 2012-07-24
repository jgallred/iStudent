//
//  EditCourseViewController.m
//  iStudent
//
//  Created by Jason Allred on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditCourseViewController.h"

@interface EditCourseViewController ()
@property (readonly) NSArray *cellLabels;
@property (retain) Course *course;
@end

@implementation EditCourseViewController

@synthesize course;
@synthesize delegate;

#define TITLE_CELL @"Title"
#define START_DATE_CELL @"Start"
#define END_DATE_CELL @"End"

- (NSArray *)cellLabels
{
    if (!cellLabels) {
        cellLabels = [[NSArray arrayWithObjects:
                       [NSArray arrayWithObject:TITLE_CELL],
                       [NSArray arrayWithObjects:
                        START_DATE_CELL, 
                        END_DATE_CELL, nil], nil] retain];
    }
    return cellLabels;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)[self.cellLabels objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
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

- (void)setValueOfCell:(UITableViewCell *)cell
{
    NSString *cellLabel = cell.textLabel.text;
    if([cellLabel isEqualToString:TITLE_CELL]) {
        cell.detailTextLabel.text = self.course.title;
    } else if([cellLabel isEqualToString:START_DATE_CELL]) {
//        [self refreshDateCell:cell withDate:self.course.startDate];
    } else if([cellLabel isEqualToString:END_DATE_CELL]) {
//        [self refreshDateCell:cell withDate:self.course.endDate];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellLabel = [[self.cellLabels objectAtIndex:indexPath.section] 
                           objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([cellLabel isEqualToString:TITLE_CELL]) {
        TextEntryViewController *textEntry = [[TextEntryViewController alloc] init];
        textEntry.title = cellLabel;
        textEntry.text = self.course.title;
        textEntry.delegate = self;
        textEntry.placeholder = @"Course Title";
        [self.navigationController pushViewController:textEntry animated:YES];
    } else if ([cellLabel isEqualToString:START_DATE_CELL]) {
//        [self showDatePickerForCell:cell withDate:self.semester.startDate];
    }  else if ([cellLabel isEqualToString:END_DATE_CELL]) {
//        [self showDatePickerForCell:cell withDate:self.semester.endDate];
    }
}

- (UITableViewCell *)selectedCell
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    return [self.tableView cellForRowAtIndexPath:path];
}

- (void) textEntry:(TextEntryViewController *)viewController didFinishWithText:(NSString *)text
{
    [self selectedCell].detailTextLabel.text = text;
    self.course.title = text;
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
