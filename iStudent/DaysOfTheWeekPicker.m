//
//  DaysTableViewController.m
//  TestUI
//
//  Created by Jason Allred on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DaysOfTheWeekPicker.h"

@interface DaysOfTheWeekPicker ()
@property (retain, nonatomic) NSMutableArray *daysOfWeek;
@property (readonly) NSArray *daysOfWeekTitles;
@end

@implementation DaysOfTheWeekPicker

@synthesize delegate, daysOfWeek, selectedDays;

- (NSArray *)daysOfWeekTitles
{
    if (daysOfWeekTitles == nil) {
        daysOfWeekTitles = [[NSArray arrayWithObjects:
                             @"Sunday", 
                             @"Monday", 
                             @"Tuesday",
                             @"Wednesday",
                             @"Thursday",
                             @"Friday",
                             @"Saturday",nil] retain];
    }
    return daysOfWeekTitles;
}

- (NSMutableArray *)daysOfWeek
{
    if (daysOfWeek == nil) {
        daysOfWeek = [[NSMutableArray arrayWithObjects:
                               [NSNumber numberWithBool:NO],
                               [NSNumber numberWithBool:NO],
                               [NSNumber numberWithBool:NO],
                               [NSNumber numberWithBool:NO],
                               [NSNumber numberWithBool:NO],
                               [NSNumber numberWithBool:NO],
                               [NSNumber numberWithBool:NO],nil] retain];
    }
    return daysOfWeek;
}

/**
 Checks/Unchecks the table cell
 @param cell
 @param val If YES the cell is marked with a check mark, otherwise it is cleared
 */
- (void)markDayCell:(UITableViewCell *)cell withValue:(NSNumber *)val
{
    if ([val boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)showSelectedDays
{
    for (int i = 0; i < self.daysOfWeek.count; i++) {
        UITableViewCell *cell = [self.tableView 
                                 cellForRowAtIndexPath:[NSIndexPath 
                                                        indexPathForRow:i inSection:0]];
        [self markDayCell:cell withValue:[self.daysOfWeek objectAtIndex:i]];
    }
}

- (void)setSelectedDays:(NSArray *)days
{
    self.daysOfWeek = nil;
    for (NSNumber *day in days) {
        int index = [day intValue];
        if (index < self.daysOfWeek.count) {
            [self.daysOfWeek 
             replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
        }
    }
    [self showSelectedDays];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showSelectedDays];
}

- (void)donePressed:(UIBarButtonItem *)sender
{
    NSMutableArray *finalDays = [NSMutableArray array];
    for (int i = 0; i < self.daysOfWeek.count; i++) {
        NSNumber *day  = [self.daysOfWeek objectAtIndex:i];
        if ([day boolValue]) {
            [finalDays addObject:[NSNumber numberWithInt:i]];
        }
    }
    [self.delegate daysOfTheWeekPicker:self didFinishWithDays:finalDays];
}

- (void) cancelPressed:(UIBarButtonItem *)sender
{
    [self.delegate daysOfTheWeekPickerDidCancel:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.daysOfWeek.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DayOfWeekCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.daysOfWeekTitles objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *day = [self.daysOfWeek objectAtIndex:indexPath.row];
    NSNumber *newDay = [NSNumber numberWithBool:![day boolValue]];
    [self.daysOfWeek replaceObjectAtIndex:indexPath.row withObject:newDay];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self markDayCell:cell withValue:newDay];
    cell.selected = NO;
}

- (void) dealloc
{
    [daysOfWeek release];
    [daysOfWeekTitles release];
    [super dealloc];
}

@end
