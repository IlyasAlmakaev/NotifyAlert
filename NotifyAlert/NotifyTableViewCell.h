//
//  NotifyTableViewCell.h
//  NotifyAlert
//
//  Created by intent on 30/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifyTableViewController.h"

@interface NotifyTableViewCell : UITableViewCell

- (void)setup:(NSManagedObject *)notification;

@end
