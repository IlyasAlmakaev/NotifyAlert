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
<UITextFieldDelegate, UIPickerViewDelegate>
{
    NSMutableArray *pickerArray;
    UIPickerView *pickerView;
    
    NSDate *notifyDate;
    UIDatePicker *datePickerView;
}

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *repeatField;

@property (nonatomic, retain) NSDate *notifyDate;

@property (strong) NSManagedObject *notify;

@property (nonatomic) BOOL edit;

@end
