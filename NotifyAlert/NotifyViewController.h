//
//  NotifyViewController.h
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
// REVIEW Зачем?

@interface NotifyViewController : UIViewController
<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
// REVIEW Список реализуемых протоколов перенести в файл реализации.
{
    NSMutableArray *pickerArray;
    UIPickerView *pickerView;
    
    NSDate *notifyDate;
    UIDatePicker *datePickerView;
}
// REVIEW Заменить на property в файле реализации.

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *repeatField;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
- (IBAction)switcherPressed:(id)sender;
// REVIEW Зачем?

@property (strong) NSManagedObject *notify;

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSDate *notifyDate;

@property (nonatomic) BOOL edit;
// REVIE Перенести все свойства, что можно, в файл реализации.

@end
