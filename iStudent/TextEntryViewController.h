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
- (void)textEntry:(TextEntryViewController *)viewController didFinishWithText:(NSString *)text;

@optional
-(void)textEntrydidCancel:(TextEntryViewController *)viewController;

@end

@interface TextEntryViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *titleField;
    id<TextEntryViewControllerDelegate> delegate;
    NSString *placeholder;
    NSString *text;
}

@property (assign) id<TextEntryViewControllerDelegate> delegate;

@property (copy, nonatomic) NSString *placeholder;
@property (copy, nonatomic) NSString *text;

@end
