//
//  EditSemesterViewController.m
//  iStudent
//
//  Created by Jason Allred on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditSemesterViewController.h"

@interface EditSemesterViewController ()
@property (readonly) NSArray *cellLabels;
@property (retain) Semester *semester;
@end

@implementation EditSemesterViewController

@synthesize semester;
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

-(id)initWithSemester:(Semester *)aSemester
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.semester = aSemester;
        self.title = (self.semester.title.length > 0) ? self.semester.title : @"New Semester";
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

/*
 Sets the detail label of the cell with the correct data based on the cell label
 */
- (void)setValueOfCell:(UITableViewCell *)cell
{
    NSString *cellLabel = cell.textLabel.text;
    if([cellLabel isEqualToString:TITLE_CELL]) {
        cell.detailTextLabel.text = self.semester.title;
    } else if([cellLabel isEqualToString:START_DATE_CELL]) {
        [self refreshDateCell:cell withDate:self.semester.startDate];
    } else if([cellLabel isEqualToString:END_DATE_CELL]) {
        [self refreshDateCell:cell withDate:self.semester.endDate];
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
        textEntry.text = self.semester.title;
        textEntry.delegate = self;
        textEntry.placeholder = @"Semester Title";
        [self.navigationController pushViewController:textEntry animated:YES];
    } else if ([cellLabel isEqualToString:START_DATE_CELL]) {
        [self showDatePickerForCell:cell withDate:self.semester.startDate];
    }  else if ([cellLabel isEqualToString:END_DATE_CELL]) {
        [self showDatePickerForCell:cell withDate:self.semester.endDate];
    }
}

/*
 Pushes a new DatePickerViewController onto the navigation stack to edit the given NSDate
 */
- (void) showDatePickerForCell:(UITableViewCell *)cell withDate:(NSDate *)date
{
    DatePickerViewController *dvc = [[[DatePickerViewController alloc] init] autorelease];
    dvc.delegate = self;
    dvc.date = date;
    dvc.title = cell.textLabel.text;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (UITableViewCell *)selectedCell
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    return [self.tableView cellForRowAtIndexPath:path];
}

/*
 Sets the detail label of the cell with a formatted string of the NSDate
 */
- (void) refreshDateCell:(UITableViewCell *)cell withDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    cell.detailTextLabel.text = [df stringFromDate:date];
}

- (void) datePickerDidCancel:(DatePickerViewController *)vc
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) datePicker:(DatePickerViewController *)vc didFinishWithDate:(NSDate *)date
{
    if ([vc.title isEqualToString:START_DATE_CELL]) {
        self.semester.startDate = date;
    } else if ([vc.title isEqualToString:END_DATE_CELL]) {
        self.semester.endDate = date;
    }
    [self refreshDateCell:[self selectedCell] withDate:date];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) textEntry:(TextEntryViewController *)viewController didFinishWithText:(NSString *)text
{
    [self selectedCell].detailTextLabel.text = text;
    self.semester.title = text;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) textEntrydidCancel:(TextEntryViewController *)viewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)donePressed:(UIBarButtonItem *)sender
{
    [self.delegate editSemesterViewController:self didFinishWithSemester:self.semester];
}

- (void) cancelPressed:(UIBarButtonItem *)sender
{
    [self.delegate editSemesterViewController:self didCancelWithSemester:self.semester];
}

- (void) dealloc
{
    //TODO [semester release];
    [cellLabels release];
    [super dealloc];
}

@end
