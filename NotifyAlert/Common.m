//
//  Common.m
//  NotifyAlert
//
//  Created by intent on 05.03.15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "Common.h"

#import "NotifyViewController.h"

@implementation Common

-(void)showToast:(NSString *)text
{
    [self makeToast:text
                       duration:2.0
                       position:CSToastPositionCenter];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
