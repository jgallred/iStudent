//
//  TimeViewController.m
//  TestUI
//
//  Created by Jason Allred on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimePickerViewController.h"

@interface TimePickerViewController ()
@property (retain) IBOutlet UILabel *timeLabel;
@property (retain) IBOutlet UIDatePicker *timePicker;
@end

@implementation TimePickerViewController

@synthesize delegate;
@synthesize timeLabel, timePicker;

- (void) setTime:(NSDate *)aTime
{
    [time release];
    time = [aTime retain];
    
    self.timePicker.date = time;
}

- (NSDate *) time
{
    if(time == nil) {
        time = [[NSDate date] retain];
    }
    return  time;
}

- (void)donePressed:(UIBarButtonItem *)sender
{
    [self.delegate timePicker:self didFinshWithTime:self.time];
}

- (void) cancelPressed:(UIBarButtonItem *)sender
{
    [self.delegate timePickerDidCancel:self];
}

/* Updates the date label based on the time provided in the initializer */
- (void) updateLabel
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle];
    self.timeLabel.text = [df stringFromDate:self.time];
}

/* Updates the time label when the time picker value changes */
- (IBAction)timeChanged:(UIDatePicker *)sender
{
    self.time = sender.date;
    [self updateLabel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.timePicker setDate:self.time animated:NO];
    [self timeChanged:self.timePicker];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.timePicker = nil;
    self.timeLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [timeLabel release];
    [timePicker release];
    [super dealloc];
}

@end
