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
        // REVIEW Переименовать в repeatOptions. Какой смысл называть массивом массив?
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
        // REVIEW Почему 162? Почему не 163?
        pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        // REVIEW Создать picker view лишь один раз.
        // REVIEW Зачем каждый раз создавать новый?
        pickerView.delegate = self;
        pickerView.dataSource = self;
        // REVIEW И каждый раз его настраивать. Зачем когда можно это сделать
        // REVIEW ровно один раз?
        
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
        // REVIEW Никогда нельзя сравнивать с конечным локализованным значением
        // REVIEW Поменять на сравнение с внутренней переменной, никак
        // REVIEW не связанной со строкой отображения.
        
        self.repeatField.inputView = pickerView;
        
        
    }
    else if (textField == self.dateField)
    {
        // Show DatePickerView
        CGRect datePickerFrame = CGRectMake(0, 162, 0, 0);
        datePickerView = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
        [datePickerView setDatePickerMode:UIDatePickerModeDateAndTime];
        // REVIEW Тот же вопрос про 162 и про создание каждый раз.
        
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
    // REVIEW Почему не [self.view endEditing]?
    // REVIEW В чём разница между endEditing и resignFirstResponder?
    // REVIEW Почему рекомендуется использовать endEditing?
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
    // REVIEW Почему в NotifyTVC используется self.notifications.count (свойство)
    // REVIEW а тут [pickerArray count] (метод)?
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
    // REVIEW Делать ровно один раз. Какой смысл при каждом показе?
    
    NSString *dateF = NSLocalizedString(@"Remind it?", nil);
    NSString *repeatF = NSLocalizedString(@"Repeat setting is disabled", nil);
    self.nameField.placeholder = NSLocalizedString(@"Name for your remind", nil);
    // REVIEW Тоже надо делать один раз.
   
    if (self.edit == YES) {
        // REVIEW Почему не if (self.edit)?
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
            // REVIEW Скобочка уехала.
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
        // REVIEW Почему не просто else?
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
    // REVIEW Сократить портянку в 2 раза. Например, если self.switcher.on
    // REVIEW зависит от self.edit и self.notify, то конечное значение BOOL
    // REVIEW достоточно получить ровно 1 раз, после чего его присвоить по
    // REVIEW одному разу каждому виджету (switcher, dateField и т.д.).
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    // REVIEW Гораздо лучше сразу в AppDelegate присвоить
    // REVIEW NSManagedObjectContext этому классу. Какой смысл
    // REVIEW при каждом действии с базой выполнять одно и то же?
    
    self.repeatField.delegate = self;
    // REVIEW Делать лишь один раз.


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
                 // REVIEW Опять же использовать делегата для удаления уведомления.
                 // REVIEW Ни в коем случае не использовать Application НЕЯВНО.
                 
                [self.notify setValue:self.nameField.text forKey:@"name"];
                 
                [self.notify setValue:self.notifyDate forKey:@"date"];
             
                 if ([self.repeatField.text isEqual:@""]) {
                     // REVIEW Опять же использовать внутреннюю переменную,
                     // REVIEW никак не связанную с отображением.
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
                     // REVIEW Опять же...
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
                 // REVIEW Создать файл Common, в котором реализовать showToast(текст)
                 // REVIEW Нет никакого прока от указания одних и тех же значений
                 // REVIEW для duration и position при каждом вызове.
             }
             else {
             
             // New for iOS 8 - Register the notifications
             UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
             UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
             [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
             // REVIEW Опять же реализовать это с помощью делегата в AppDelegate.
             // REVIEW Ни в коем случае не использовать Application НЕЯВНО.
             
             UILocalNotification* localNotification = [[UILocalNotification alloc] init];
             localNotification.fireDate = self.notifyDate;
             localNotification.alertBody = self.nameField.text;
             localNotification.alertAction = @"Show me the item";
             localNotification.soundName = UILocalNotificationDefaultSoundName;
             localNotification.timeZone = [NSTimeZone defaultTimeZone];
             localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
             if ([self.repeatField.text isEqual: NSLocalizedString(@"Do not repeat", nil)]) {
                 // REVIEW Опять же использовать переменную,
                 // REVIEW никак не связанную с отображением.
                 
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
             // REVIEW Опять же...
             [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
             // REVIEW Опять же...
             }
             // REVIE Ещё и неверный отступ.
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
                 // REVIEW Опять же.
                 
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
         // REVIEW Почему не сразу?
     }
     else {

         [self.view makeToast:NSLocalizedString(@"Enter name for your remind", nil)
                     duration:3.0
                     position:CSToastPositionCenter];
         // REVIEW Добавить shake поля ввода.
     }
}

-(void)back {
    [self.repeatField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.dateField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    // REVIEW Зачем?
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
// REVIEW Поправить отступы.
// REVIEW Сократить портянку в 2 раза описанным выше способом.
}
@end
