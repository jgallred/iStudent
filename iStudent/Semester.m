//
//  Semester.m
//  iStudent
//
//  Created by Jason Allred on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Semester.h"


@implementation Semester

@dynamic title;
@dynamic startDate;
@dynamic endDate;

- (void) awakeFromInsert 
{
    [super awakeFromInsert];
    self.startDate = [NSDate date];
    self.endDate = [NSDate date];
}

@end
