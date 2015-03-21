//
//  NotifyViewController.h
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface NotifyViewController : UIViewController

@property (strong) NSManagedObject *notify;
@property (nonatomic) BOOL edit;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *notRepeat, *everyMinute, *everyHour, *everyDay, *everyWeek;

@end
