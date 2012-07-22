//
//  DatePickerViewController.m
//  TestUI
//
//  Created by Jason Allred on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()
@property (retain) IBOutlet UILabel *dateLabel;
@property (retain) IBOutlet UIDatePicker *datePicker;
@end

@implementation DatePickerViewController

@synthesize dateLabel, datePicker;
@synthesize delegate, date;

- (void) showDateInDateLabel:(NSDate *)aDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [df stringFromDate:aDate];
}

- (void) setDate:(NSDate *)aDate
{
    [date release];
    date = [aDate retain];
    
    self.datePicker.date = date;
    [self showDateInDateLabel:date];
}

- (NSDate *)date
{
    if(!date) {
        date = [[NSDate date] retain];
    }
    return date;
}

- (IBAction)datePickerChanged:(UIDatePicker *)sender
{
    self.date = sender.date;
}

- (void)donePressed:(UIBarButtonItem *)sender
{
    [self.delegate datePicker:self didFinishWithDate:self.date];
}

- (void) cancelPressed:(UIBarButtonItem *)sender
{
    [self.delegate datePickerDidCancel:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self.datePicker setDate:self.date animated:NO];
    [self showDateInDateLabel:date];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.dateLabel = nil;
    self.datePicker = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [dateLabel release];
    [datePicker release];
    [date release];
    [super dealloc];
}

@end
