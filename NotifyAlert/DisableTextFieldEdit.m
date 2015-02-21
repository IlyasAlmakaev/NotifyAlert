//
//  DisableTextFieldEdit.m
//  NotifyAlert
//
//  Created by intent on 13.02.15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "DisableTextFieldEdit.h"

@implementation DisableTextFieldEdit

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu) {
        [UIMenuController sharedMenuController].menuVisible = NO;
        // REVIEW Это ведь переменная menu. Зачем второй раз её получать?
    }
    return NO;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}

-(NSArray *)selectionRectsForRange:(UITextRange *)range {
    return nil;
}

@end
