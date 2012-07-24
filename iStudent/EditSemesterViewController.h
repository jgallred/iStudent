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
- (void) editSemesterViewController:(EditSemesterViewController *)viewController
              didFinishWithSemester:(Semester *)semester;
@optional
- (void) editSemesterViewController:(EditSemesterViewController *)viewController
              didCancelWithSemester:(Semester *)semester;


@end

@interface EditSemesterViewController : UITableViewController <DatePickerViewControllerDelegate, TextEntryViewControllerDelegate>
{
    @private
    NSArray *cellLabels;
    Semester *semester;
    
    id <EditSemesterViewControllerDelegate> delegate;
}

-(id)initWithSemester:(Semester *)aSemester;
@property (assign) id <EditSemesterViewControllerDelegate> delegate;

@end
