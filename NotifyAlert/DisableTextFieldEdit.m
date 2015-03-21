//
//  DisableTextFieldEdit.m
//  NotifyAlert
//
//  Created by intent on 13.02.15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "DisableTextFieldEdit.h"

@implementation DisableTextFieldEdit

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

-(NSArray *)selectionRectsForRange:(UITextRange *)range
{
    return nil;
}

@end
