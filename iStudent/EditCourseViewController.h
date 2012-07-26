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
- (void) editCourseViewController:(EditCourseViewController *)viewController
              didFinishWithCourse:(Course *)course;
@optional
- (void) editCourseViewController:(EditCourseViewController *)viewController
              didCancelWithCourse:(Course *)course;

@end

@interface EditCourseViewController : UITableViewController <TextEntryViewControllerDelegate>
{
    @private
    NSArray *cellLabels;
    NSArray *sectionLabels;
    Course *course;
    
    id <EditCourseViewControllerDelegate> delegate;
}

-(id)initWithCourse:(Course *)aCourse;
@property (assign) id <EditCourseViewControllerDelegate> delegate;

@end
