//
//  FirstViewController.h
//  TestUI
//
//  Created by Jason Allred on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextEntryViewController;

@protocol TextEntryViewControllerDelegate

@required
/*
 Notifies the delegate that the user finished making changes to the selected text
 */
- (void)textEntry:(TextEntryViewController *)viewController didFinishWithText:(NSString *)text;

@optional
/*
 Notifies the delegate that the user canceled any changes
 */
-(void)textEntrydidCancel:(TextEntryViewController *)viewController;

@end

/*
 Edits a small amount of text
 */
@interface TextEntryViewController : UIViewController <UITextFieldDelegate>
{
    /* Displays the current value of the text */
    IBOutlet UITextField *titleField;
    /* The view controller's delegate */
    id<TextEntryViewControllerDelegate> delegate;
    /* The place holder of the text input */
    NSString *placeholder;
    /* The text to edit */
    NSString *text;
}

@property (assign) id<TextEntryViewControllerDelegate> delegate;

@property (copy, nonatomic) NSString *placeholder;
@property (copy, nonatomic) NSString *text;

@end
