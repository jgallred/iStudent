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
@property (retain) MeetingTime *meetingTime;
@end

@implementation EditMeetingTimeViewController

@synthesize delegate, meetingTime;

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
                            START_TIME_CELL, END_TIME_CELL, nil], nil] retain];
    }
    return cellLabels;
}

- (id) initWithMeetingTime:(MeetingTime *)aMeetingTime
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self) {
        self.meetingTime = aMeetingTime;
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
    static NSString *CellIdentifier = @"MeetingTimeDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.cellLabels objectAtIndex:indexPath.section] 
                           objectAtIndex:indexPath.row];
    
    [self setDetailForCell:cell];
    
    return cell;
}

/*
 Sets the detail label of the table cell based on the cell label
 */
-(void)setDetailForCell:(UITableViewCell *)cell
{
    if ([cell.textLabel.text isEqualToString:DAYS_CELL]) {
        [self refreshDaysCell:cell];
    } else if ([cell.textLabel.text isEqualToString:START_TIME_CELL]) {
        [self refreshTimeCell:cell withTime:self.meetingTime.startTime];
    } else if ([cell.textLabel.text isEqualToString:END_TIME_CELL]) {
        [self refreshTimeCell:cell withTime:self.meetingTime.endTime];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NSString *cellLabel = [[self.cellLabels objectAtIndex:indexPath.section] 
                           objectAtIndex:indexPath.row];
    
    if([cellLabel isEqualToString:DAYS_CELL]) {
        DaysOfTheWeekPicker *dowp = [[[DaysOfTheWeekPicker alloc] init] autorelease];
        dowp.delegate = self;
        dowp.selectedDays = [self getDayPickerDaysForMeetingTime];
        dowp.title = cellLabel;
        [self.navigationController pushViewController:dowp animated:YES];
    } else if ([cellLabel isEqualToString:START_TIME_CELL] ) {
        [self editTime:self.meetingTime.startTime withTitle:cellLabel];
    } else if ([cellLabel isEqualToString:END_TIME_CELL] ) {
        [self editTime:self.meetingTime.endTime withTitle:cellLabel];
    }
}

/*
 Pushes a TimePickerViewController onto the navigation stack and sets it to edit the specified time
 @param time The NSDate to edit
 @param title The title of the new view controller
 */
-(void)editTime:(NSDate *)time withTitle:(NSString *)title
{
    TimePickerViewController *tvc = [[[TimePickerViewController alloc] init] autorelease];
    tvc.delegate = self;
    tvc.time = time;
    tvc.title = title;
    [self.navigationController pushViewController:tvc animated:YES];
}

/*
 Sets the cell detail label with the formatted string representation of the time
 */
- (void) refreshTimeCell:(UITableViewCell *)cell withTime:(NSDate *)time
{   
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle]; 
    cell.detailTextLabel.text = [df stringFromDate:time];
}

/*
 Returns the selected table cell
 */
- (UITableViewCell *)selectedCell
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    return [self.tableView cellForRowAtIndexPath:path];
}

- (void) timePicker:(TimePickerViewController *)vc didFinshWithTime:(NSDate *)time
{
    UITableViewCell *cell = [self selectedCell];    
    if ([cell.textLabel.text isEqualToString:START_TIME_CELL] ) {
        self.meetingTime.startTime = time;
    } else if ([cell.textLabel.text isEqualToString:END_TIME_CELL] ) {
        self.meetingTime.endTime = time;
    }
    [self refreshTimeCell:cell withTime:time];    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) timePickerDidCancel:(TimePickerViewController *)vc
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 Populates the cell's detail label with a string representation of the selected days of the week
 */
- (void) refreshDaysCell:(UITableViewCell *)cell
{
    cell.detailTextLabel.text = [MeetingTime stringForDaysOfMeetingTime:self.meetingTime];
}

/*
 Sets the MeetingTime daysOfWeek bit array according to the array of NSNumbers from 
 the DaysOfTheWeekView Controller
 */
-(void)setMeetingTimeDaysFromDayPickerDays:(NSArray *)days
{
    int newDays = 0x00;
    for (NSNumber *day in days) {
        switch ([day intValue]) {
            case DaysOfTheWeekSunday:
                newDays = newDays | MeetingTimeSunday;
                break;
            case DaysOfTheWeekMonday:
                newDays = newDays | MeetingTimeMonday;
                break;
            case DaysOfTheWeekTuesday:
                newDays = newDays | MeetingTimeTuesday;
                break;
            case DaysOfTheWeekWednesday:
                newDays = newDays | MeetingTimeWednesday;
                break;
            case DaysOfTheWeekThursday:
                newDays = newDays | MeetingTimeThursday;
                break;
            case DaysOfTheWeekFriday:
                newDays = newDays | MeetingTimeFriday;
                break;
            case DaysOfTheWeekSaturday:
                newDays = newDays | MeetingTimeSaturday;
                break;
            default:
                break;
        }
    }
    self.meetingTime.daysOfWeek = [NSNumber numberWithInt:newDays];
}

/*
 Prepares an array of NSNumbers for the DaysOfTheWeekViewController based on the bit 
 array of the MeetingTime
 */
-(NSArray *)getDayPickerDaysForMeetingTime
{
    NSMutableArray *days = [NSMutableArray array];
    int daysOfWeek = [self.meetingTime.daysOfWeek intValue];
    if(daysOfWeek & MeetingTimeSunday) {
        [days addObject:[NSNumber numberWithInt:DaysOfTheWeekSunday]];
    }
    if(daysOfWeek & MeetingTimeMonday) {
        [days addObject:[NSNumber numberWithInt:DaysOfTheWeekMonday]];
    } 
    if(daysOfWeek & MeetingTimeTuesday) {
        [days addObject:[NSNumber numberWithInt:DaysOfTheWeekTuesday]];
    } 
    if(daysOfWeek & MeetingTimeWednesday) {
        [days addObject:[NSNumber numberWithInt:DaysOfTheWeekWednesday]];
    } 
    if(daysOfWeek & MeetingTimeThursday) {
        [days addObject:[NSNumber numberWithInt:DaysOfTheWeekThursday]];
    } 
    if(daysOfWeek & MeetingTimeFriday) {
        [days addObject:[NSNumber numberWithInt:DaysOfTheWeekFriday]];
    } 
    if(daysOfWeek & MeetingTimeSaturday) {
        [days addObject:[NSNumber numberWithInt:DaysOfTheWeekSaturday]];
    }
    return days;
}

- (void) daysOfTheWeekPicker:(DaysOfTheWeekPicker *)vc didFinishWithDays:(NSArray *)days
{
    UITableViewCell *cell = [self selectedCell];
    [self setMeetingTimeDaysFromDayPickerDays:days];
    [self refreshDaysCell:cell];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) daysOfTheWeekPickerDidCancel:(DaysOfTheWeekPicker *)vc
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)donePressed:(UIBarButtonItem *)sender
{
    [self.delegate editMeetingTimeViewController:self didFinishWithMeetingTime:self.meetingTime];
}

- (void) cancelPressed:(UIBarButtonItem *)sender
{
    [self.delegate editMeetingTimeViewController:self didCancelWithMeetingTime:self.meetingTime];
}

- (void) dealloc
{
    [cellLabels release];
    [sectionHeaders release];
    //TODO [meetingTime release];
    [super dealloc];
}

@end
