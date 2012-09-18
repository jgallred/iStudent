//
//  NSManagedObject-IsNew.h
//
// Found online.  Provides support for determining if the NSManagedObject is new.

#import <Foundation/Foundation.h>


@interface NSManagedObject(IsNew)
/*!
 @method isNew 
 @abstract   Returns YES if this managed object is new and has not yet been saved yet into the persistent store.
 */
-(BOOL)isNew;
@end