//
//  EditSemesterViewController.h
//  iStudent
//
//  Created by Jason Allred on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Semester.h"
#import "DatePickerViewController.h"
#import "TextEntryViewController.h"

@class EditSemesterViewController;

@protocol EditSemesterViewControllerDelegate

@required
/*
 Notifies the delegate that the user finished making changes to the semester
 */
- (void) editSemesterViewController:(EditSemesterViewController *)viewController
              didFinishWithSemester:(Semester *)semester;
@optional
/*
 Notifies the delegate that the user canceled any changes to the semester
 */
- (void) editSemesterViewController:(EditSemesterViewController *)viewController
              didCancelWithSemester:(Semester *)semester;
@end

/*
 View Controller for editing a semester
 */
@interface EditSemesterViewController : UITableViewController <DatePickerViewControllerDelegate, TextEntryViewControllerDelegate>
{
    @private
    /* An array of NSStrings for table cell labels */
    NSArray *cellLabels;
    /* The Semester instance represented by this view controller */
    Semester *semester;
    
    /* The view controller's delegate */
    id <EditSemesterViewControllerDelegate> delegate;
}

/*
 Initializes the view controller with the specified semester
 */
-(id)initWithSemester:(Semester *)aSemester;

@property (assign) id <EditSemesterViewControllerDelegate> delegate;

@end
