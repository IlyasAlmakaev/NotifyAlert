//
//  NotifyViewController.m
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "NotifyViewController.h"
#import "NotifyData.h"
#import "UIView+Toast.h"
#import "DisableTextFieldEdit.h"


@interface NotifyViewController ()


@end

@implementation NotifyViewController


    // Block text for repeatField and dateField
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = NSLocalizedString(@"New Remind", nil);

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
        
        pickerArray = [[NSMutableArray alloc] init];
        
        [pickerArray addObject:NSLocalizedString(@"Do not repeat", nil)];
        [pickerArray addObject:NSLocalizedString(@"Every minute", nil)];
        [pickerArray addObject:NSLocalizedString(@"Every hour", nil)];
        [pickerArray addObject:NSLocalizedString(@"Every day", nil)];
        [pickerArray addObject:NSLocalizedString(@"Every week", nil)];
        
    }
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.repeatField)
    {
        // Show PickerView
        CGRect pickerFrame = CGRectMake(0, 162, 0, 0);
        pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        if ([self.repeatField.text isEqual: NSLocalizedString(@"Do not repeat", nil)]) {
            [pickerView selectRow:0 inComponent:0 animated:NO];
        }
        else if ([self.repeatField.text isEqual: NSLocalizedString(@"Every minute", nil)]) {
            
            [pickerView selectRow:1 inComponent:0 animated:NO];
        }
        else if ([self.repeatField.text isEqual: NSLocalizedString(@"Every hour", nil)]) {
            
            [pickerView selectRow:2 inComponent:0 animated:NO];
        }
        else if ([self.repeatField.text isEqual: NSLocalizedString(@"Every day", nil)]) {
            
            [pickerView selectRow:3 inComponent:0 animated:NO];
        }
        else if ([self.repeatField.text isEqual: NSLocalizedString(@"Every week", nil)]) {
            
            [pickerView selectRow:4 inComponent:0 animated:NO];
        }
        
        self.repeatField.inputView = pickerView;
        
        
    }
    else if (textField == self.dateField)
    {
        // Show DatePickerView
        CGRect datePickerFrame = CGRectMake(0, 162, 0, 0);
        datePickerView = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
        [datePickerView setDatePickerMode:UIDatePickerModeDateAndTime];
        
        self.notifyDate = [datePickerView date];
        // DateFormat ----
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"HH:mm / dd.MM.yy"];
        
        [self.dateField setText:[format stringFromDate:self.notifyDate]];
        
        self.dateField.inputView = datePickerView;
        
        [datePickerView addTarget:self action:@selector(didChangeDate:) forControlEvents:UIControlEventValueChanged];
        
        
        
    }
}

-(void)didChangeDate:(id)sender
{
    // DateFormat ----
    self.notifyDate = [datePickerView date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm / dd.MM.yy"];
    
    [self.dateField setText:[format stringFromDate:self.notifyDate]];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.repeatField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.dateField resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.repeatField.text = [pickerArray objectAtIndex:row];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52/255. green:52/255. blue:52/255. alpha:1];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    NSString *dateF = NSLocalizedString(@"Remind it?", nil);
    NSString *repeatF = NSLocalizedString(@"Repeat setting is disabled", nil);
    self.nameField.placeholder = NSLocalizedString(@"Name for your remind", nil);
   
    if (self.edit == YES) {
        self.switcher.on = true;
        self.dateField.enabled = true;
        self.repeatField.enabled = true;
        
        [self.nameField setText:[self.notify valueForKey:@"name"]];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"HH:mm / dd.MM.yy"];
        [self.dateField setText:[format stringFromDate:[self.notify valueForKey:@"date"]]];
        
        self.notifyDate = [self.notify valueForKey:@"date"];
        
        [self.repeatField setText:[self.notify valueForKey:@"repeat"]];
        
        if ([self.notify valueForKey:@"date"] == nil && [self.notify valueForKey:@"repeat"] == nil)  {
            self.switcher.on = false;
            self.dateField.enabled = false;
            self.repeatField.enabled = false;
            self.dateField.text=nil;
            self.repeatField.text=nil;
            self.dateField.placeholder = dateF;
            self.repeatField.placeholder = repeatF;
            NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
            [usrDefaults setInteger:0 forKey:@"Index"];
        }
        
    } else if (self.edit == NO) {
        self.switcher.on = false;
        self.dateField.enabled = false;
        self.repeatField.enabled = false;
        self.dateField.text=nil;
        self.repeatField.text=nil;
        self.dateField.placeholder = dateF;
        self.repeatField.placeholder = repeatF;
        self.nameField.text=nil;
        NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
        [usrDefaults setInteger:0 forKey:@"Index"];
    }
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.repeatField.delegate = self;


}
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)save
{
    NSString *ErrorString = NSLocalizedString(@"Error", nil);
     if (self.nameField.text && self.nameField.text.length > 0) {
         
         if (self.switcher.on) {
             
             if (self.notify && self.edit == YES) {
                 
                 // Delete local notification
                 NSString *notificationName = [self.notify valueForKey:@"name"];
                 NSArray *localNotifications = [[UIApplication sharedApplication]  scheduledLocalNotifications];
                 for(UILocalNotification *localNotification in localNotifications) {
                     if ([localNotification.alertBody isEqualToString:notificationName])
                     {
                         // Delete
                         [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                     }
                 }
                 
                [self.notify setValue:self.nameField.text forKey:@"name"];
                 
                [self.notify setValue:self.notifyDate forKey:@"date"];
             
                 if ([self.repeatField.text isEqual:@""]) {
                     [self.notify setValue:self.repeatField.placeholder forKey:@"repeat"];
                 }
                 else {
                     [self.notify setValue:self.repeatField.text forKey:@"repeat"];
                 }
                

             }
             else {
                 NotifyData * notifyAdd = [NSEntityDescription insertNewObjectForEntityForName:@"NotifyData"
                                                                        inManagedObjectContext:self.managedObjectContext];
                 notifyAdd.name = self.nameField.text;
                 [notifyAdd setValue:self.notifyDate forKey:@"date"];
                 if ([self.repeatField.text isEqual:@""]) {
                     notifyAdd.repeat = self.repeatField.placeholder;
                 }
                 else {
                     notifyAdd.repeat = self.repeatField.text;
                 }
             }
             
             NSError *error = nil;
             if (![self.managedObjectContext save:&error]){
                 [self.view makeToast:(@"%@: %@ %@", ErrorString, error, [error localizedDescription])
                             duration:3.5
                             position:CSToastPositionCenter];
             }
             else {
             
             // New for iOS 8 - Register the notifications
             UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
             UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
             [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
             
             UILocalNotification* localNotification = [[UILocalNotification alloc] init];
             localNotification.fireDate = self.notifyDate;
             localNotification.alertBody = self.nameField.text;
             localNotification.alertAction = @"Show me the item";
             localNotification.soundName = UILocalNotificationDefaultSoundName;
             localNotification.timeZone = [NSTimeZone defaultTimeZone];
             localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
             if ([self.repeatField.text isEqual: NSLocalizedString(@"Do not repeat", nil)]) {
                 
                 localNotification.repeatInterval = 0;
                 
             }
             else if ([self.repeatField.text isEqual: NSLocalizedString(@"Every minute", nil)]) {
                 
                 localNotification.repeatInterval = NSCalendarUnitMinute;
             }
             else if ([self.repeatField.text isEqual: NSLocalizedString(@"Every hour", nil)]) {
                 
                 localNotification.repeatInterval = NSCalendarUnitHour;
             }
             else if ([self.repeatField.text isEqual: NSLocalizedString(@"Every day", nil)]) {
                 
                 localNotification.repeatInterval = NSCalendarUnitDay;
             }
             else if ([self.repeatField.text isEqual: NSLocalizedString(@"Every week", nil)]) {
                 
                 localNotification.repeatInterval = NSCalendarUnitWeekday;
             }
             [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
             }
         }
         // switch off
         else {
             if (self.notify && self.edit == YES) {
                 [self.notify setValue:self.nameField.text forKey:@"name"];
                 [self.notify setValue:nil forKey:@"date"];
                 [self.notify setValue:nil forKey:@"repeat"];
                 
                 // Delete local notification
                 NSString *notificationName = [self.notify valueForKey:@"name"];
                 NSArray *localNotifications = [[UIApplication sharedApplication]  scheduledLocalNotifications];
                 for(UILocalNotification *localNotification in localNotifications) {
                     if ([localNotification.alertBody isEqualToString:notificationName])
                     {
                         // Delete
                         [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                     }
                 }
                 
                 NSError *error = nil;
                 if (![self.managedObjectContext save:&error]){
                     [self.view makeToast:(@"%@: %@ %@", ErrorString, error, [error localizedDescription])
                                 duration:3.5
                                 position:CSToastPositionCenter];
                 }
                 
             }
             else {
                 NotifyData * notifyAdd = [NSEntityDescription insertNewObjectForEntityForName:@"NotifyData"
                                                                        inManagedObjectContext:self.managedObjectContext];
                 notifyAdd.name = self.nameField.text;
                 
                 NSError *error = nil;
                 if (![self.managedObjectContext save:&error]){
                     [self.view makeToast:(@"%@: %@ %@", ErrorString, error, [error localizedDescription])
                                 duration:3.5
                                 position:CSToastPositionCenter];
                 }
             }
         }

         
         // Dismiss the view controller
         [self performSelector:@selector(back) withObject:nil afterDelay:3.5];
     }
     else {

         [self.view makeToast:NSLocalizedString(@"Enter name for your remind", nil)
                     duration:3.0
                     position:CSToastPositionCenter];
     }
}

-(void)back {
    [self.repeatField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.dateField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)switcherPressed:(id)sender {
    if (self.switcher.on) {
        self.dateField.enabled = true;
        self.repeatField.enabled = true;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"HH:mm / dd.MM.yy"];
        [self.dateField setText:[format stringFromDate:[NSDate date]]];
        self.notifyDate = [NSDate date];
        self.repeatField.text = nil;
        self.repeatField.placeholder = [pickerArray objectAtIndex:0];
        
    }
else
{
    self.dateField.enabled = false;
    self.repeatField.enabled = false;
    self.dateField.text = nil;
    self.repeatField.text = nil;
    self.dateField.placeholder = NSLocalizedString(@"Remind it?", nil);
    self.repeatField.placeholder = NSLocalizedString(@"Repeat setting is disabled", nil);
}
}
@end
