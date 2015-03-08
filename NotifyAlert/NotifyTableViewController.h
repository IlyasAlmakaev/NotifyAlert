//
//  NotifyTableViewController.h
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifyViewController.h"

@interface NotifyTableViewController : UITableViewController

@property (strong, nonatomic) AppDelegate *appD;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
