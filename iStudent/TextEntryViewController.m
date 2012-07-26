//
//  FirstViewController.m
//  TestUI
//
//  Created by Jason Allred on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextEntryViewController.h"

@interface TextEntryViewController ()
@property (retain) IBOutlet UITextField *titleField;
@end

@implementation TextEntryViewController

@synthesize titleField, delegate, text, placeholder;

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.titleField.text = self.text;
    self.titleField.placeholder = self.placeholder;
    
    [self.titleField becomeFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    return [self.titleField resignFirstResponder];
}
							

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate textEntry:self didFinishWithText:self.titleField.text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.titleField.delegate = self;
    
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
    // Release any retained subviews of the main view.
    self.titleField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)donePressed:(UIBarButtonItem *)sender
{
    [self.delegate textEntry:self didFinishWithText:self.titleField.text];
}

- (void) cancelPressed:(UIBarButtonItem *)sender
{
    [self.delegate textEntrydidCancel:self];
}

- (void) dealloc
{
    [titleField release];
    [text release];
    [placeholder release];
    [super dealloc];
}

@end
