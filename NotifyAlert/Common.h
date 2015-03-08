//
//  Common.h
//  NotifyAlert
//
//  Created by intent on 05.03.15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import "NotifyViewController.h"

@interface Common : UIView

- (void)showToast:(NSString *)text view:(UIViewController *)view;


@end
