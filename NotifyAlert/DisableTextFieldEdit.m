//
//  DisableTextFieldEdit.m
//  NotifyAlert
//
//  Created by intent on 13.02.15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "DisableTextFieldEdit.h"

@implementation DisableTextFieldEdit

        // REVIEW Это ведь переменная menu. Зачем второй раз её получать?
        // ANSWER Убрал. Это нужно было чтобы не выводилось контекстное меню. Это решение оказалось лишним при коде написанным ниже.

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

-(NSArray *)selectionRectsForRange:(UITextRange *)range
{
    return nil;
}

@end
