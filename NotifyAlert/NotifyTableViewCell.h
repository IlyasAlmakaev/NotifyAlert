//
//  NotifyTableViewCell.h
//  NotifyAlert
//
//  Created by intent on 30/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameRemind;
@property (weak, nonatomic) IBOutlet UILabel *dateRemind;
@property (weak, nonatomic) IBOutlet UILabel *timerRemind;
@property (weak, nonatomic) IBOutlet UIImageView *imageRepeat;

@end
