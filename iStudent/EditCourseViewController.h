//
//  EditCourseViewController.h
//  iStudent
//
//  Created by Jason Allred on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "TextEntryViewController.h"

@class EditCourseViewController;

@protocol EditCourseViewControllerDelegate

@required
/*
 Notifies the delegate that the user finished making changes to the course
 */
- (void) editCourseViewController:(EditCourseViewController *)viewController
              didFinishWithCourse:(Course *)course;
@optional
/*
 Notifies the delegate that the user canceled any changes to the course
 */
- (void) editCourseViewController:(EditCourseViewController *)viewController
              didCancelWithCourse:(Course *)course;

@end

/*
 View Controller for editing a course
 */
@interface EditCourseViewController : UITableViewController <TextEntryViewControllerDelegate>
{
    @private
    /* An array of NSStrings for table section headers */
    NSArray *cellLabels;
    /* An array of NSStrings for table cell labels */
    NSArray *sectionLabels;
    /* The Course instance represented by this view controller */
    Course *course;
    
    /* The view controller's delegate */
    id <EditCourseViewControllerDelegate> delegate;
}

/*
 Initializes the view controller with the specified course
 */
-(id)initWithCourse:(Course *)aCourse;

@property (assign) id <EditCourseViewControllerDelegate> delegate;

@end
