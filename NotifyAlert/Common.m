//
//  Common.m
//  NotifyAlert
//
//  Created by intent on 05.03.15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "Common.h"

@implementation Common

- (void)showToast:(NSString *)text view:(UIViewController *)view
{
    [view.view makeToast:text
                duration:2.0
                position:CSToastPositionCenter];
}

@end
