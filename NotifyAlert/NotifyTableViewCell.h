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

// REVIEW Почему не в файле реализации?
// ANSWER Исправил.

- (void)setup:(NSManagedObject *)notification;

@end
