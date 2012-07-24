//
//  DaysAndTimeViewController.m
//  TestUI
//
//  Created by Jason Allred on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditMeetingTimeViewController.h"

@interface EditMeetingTimeViewController ()
@property (readonly) NSArray *sectionHeaders;
@property (readonly) NSArray *cellLabels;
@end

@implementation EditMeetingTimeViewController

@synthesize values, delegate;

- (NSArray *)sectionHeaders
{
    if (!sectionHeaders) {
        sectionHeaders = [[NSArray arrayWithObjects:
                           @"Days",
                           @"Time", nil] retain];
    }
    return sectionHeaders;
}

#define DAYS_CELL @"Days"
#define START_TIME_CELL @"Start"
#define END_TIME_CELL @"End"

- (NSArray *)cellLabels
{
    if (!cellLabels) {
        cellLabels = [[NSArray arrayWithObjects:
                           [NSArray arrayWithObject:DAYS_CELL],
                           [NSArray arrayWithObjects:
                            START_TIME_CELL, 
                            END_TIME_CELL, nil], nil] retain];
    }
    return cellLabels;
}

- (NSMutableDictionary *)values
{
    if(values == nil) {
        values = [[NSMutableDictionary dictionary] retain];
    }
    return values;
}
- (void) refreshTimeCell:(UITableViewCell *)cell 
{
    NSString *cellLabel = cell.textLabel.text;
    NSDate *aTime = [self.values objectForKey:cellLabel];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle]; 
    
    cell.detailTextLabel.text = [df stringFromDate:aTime];
}

- (UITableViewCell *)selectedCell
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    return [self.tableView cellForRowAtIndexPath:path];
}

- (void) timePicker:(TimePickerViewController *)vc didFinshWithTime:(NSDate *)aDate
{
    UITableViewCell *cell = [self selectedCell];    
    [self.values setObject:aDate forKey:cell.textLabel.text];    
    [self refreshTimeCell:cell];    
    [self dismissModalViewControllerAnimated:YES];
}

- (void) timePickerDidCancel:(TimePickerViewController *)vc
{
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *) stringForDay:(NSNumber *)day
{
    switch ([day intValue]) {
        case DaysOfTheWeekSunday:
            return @"Su";
        case DaysOfTheWeekMonday:
            return @"M";
        case DaysOfTheWeekTuesday:
            return @"Tu";
        case DaysOfTheWeekWednesday:
            return @"W";
        case DaysOfTheWeekThursday:
            return @"Th";
        case DaysOfTheWeekFriday:
            return @"F";
        case DaysOfTheWeekSaturday:
            return @"Sa";
        default:
            return @"Unknown";
    }
}

- (NSString *) textForDays:(NSArray *)days
{
    NSMutableString *text = [NSMutableString string];
    for (NSNumber *day in days) {
        [text appendString:[self stringForDay:day]];
    }
    return text;
}

- (void) refreshDaysCell:(UITableViewCell *)cell
{
    NSString *cellLabel = cell.textLabel.text;
    NSArray *days = [self.values objectForKey:cellLabel];
    cell.detailTextLabel.text = [self textForDays:days];
}

- (void) daysOfTheWeekPicker:(DaysOfTheWeekPicker *)vc didFinishWithDays:(NSArray *)days
{
    UITableViewCell *cell = [self selectedCell];
    [self.values setObject:days forKey:cell.textLabel.text];
    [self refreshDaysCell:cell];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) daysOfTheWeekPickerDidCancel:(DaysOfTheWeekPicker *)vc
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)donePressed:(UIBarButtonItem *)sender
{
    [self.delegate daysAndTime:self didFinishWithValues:self.values];
}

- (void) cancelPressed:(UIBarButtonItem *)sender
{
    [self.delegate daysAndTimeDidCancel:self];
}

- (id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self) {
        
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section < self.sectionHeaders.count) {
        return [self.sectionHeaders objectAtIndex:section];
    }
    return nil;
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
    
    if ([cell.textLabel.text isEqualToString:DAYS_CELL]) {
        [self refreshDaysCell:cell];
    } else {
        [self refreshTimeCell:cell];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NSString *cellLabel = [[self.cellLabels objectAtIndex:indexPath.section] 
                           objectAtIndex:indexPath.row];
    
    if([cellLabel isEqualToString:DAYS_CELL]) {
        DaysOfTheWeekPicker *dowp = [[[DaysOfTheWeekPicker alloc] init] autorelease];
        dowp.delegate = self;
        dowp.selectedDays = [self.values objectForKey:cellLabel];
        dowp.title = cellLabel;
        UINavigationController *nvc = [[[UINavigationController alloc] 
                                        initWithRootViewController:dowp] autorelease];
        [self presentModalViewController:nvc animated:YES];
    } else if ([cellLabel isEqualToString:START_TIME_CELL] 
               || [cellLabel isEqualToString:END_TIME_CELL] ) {
        TimePickerViewController *tvc = [[[TimePickerViewController alloc] init] autorelease];
        tvc.delegate = self;
        tvc.time = [self.values objectForKey:cellLabel];
        tvc.title = cellLabel;
        UINavigationController *nvc = [[[UINavigationController alloc] 
                                        initWithRootViewController:tvc] autorelease];
        [self presentModalViewController:nvc animated:YES];
    }
}

- (void) dealloc
{
    [values release];
    [cellLabels release];
    [sectionHeaders release];
    [super dealloc];
}

@end
