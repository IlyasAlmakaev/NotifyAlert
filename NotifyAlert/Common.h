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

@property (strong, nonatomic) NotifyViewController *notifyViewC;

- (void)showToast:(NSString *)text;


@end
