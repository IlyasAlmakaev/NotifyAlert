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


@interface NotifyViewController ()

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation NotifyViewController
@synthesize repeatField;
@synthesize nameField;
@synthesize dateField;
@synthesize notifyDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Отменить" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    }
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == repeatField)
    {
        // Show PickerView
        CGRect pickerFrame = CGRectMake(0, 162, 0, 0);
        pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        
        repeatField.text = [pickerArray objectAtIndex:0];
        repeatField.inputView = pickerView;
        
        pickerView.delegate = self;
    }
    else if (textField == dateField)
    {
        // Show DatePickerView
        CGRect datePickerFrame = CGRectMake(0, 162, 0, 0);
        datePickerView = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
        [datePickerView setDatePickerMode:UIDatePickerModeDateAndTime];
        [datePickerView setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
        
        notifyDate = [datePickerView date];
        // DateFormat ----
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy/MM/dd HH:mm"];
        
        [dateField setText:[format stringFromDate:self.notifyDate]];
        
        dateField.inputView = datePickerView;
        
        [datePickerView addTarget:self action:@selector(didChangeDate:) forControlEvents:UIControlEventValueChanged];
        
        
        
    }
}

-(void)didChangeDate:(id)sender
{
    // DateFormat ----
    notifyDate = [datePickerView date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    [dateField setText:[format stringFromDate:self.notifyDate]];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [repeatField resignFirstResponder];
    [nameField resignFirstResponder];
    [dateField resignFirstResponder];
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
    repeatField.text = [pickerArray objectAtIndex:row];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Do any additional setup after loading the view from its nib.
   
    if (_edit == YES) {
        [self.nameField setText:[self.notify valueForKey:@"name"]];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy/MM/dd HH:mm"];
        [self.dateField setText:[format stringFromDate:[self.notify valueForKey:@"date"]]];
        
        [self.repeatField setText:[self.notify valueForKey:@"repeat"]];
    } else if (_edit == NO) {
        nameField.text=nil;
        dateField.text=nil;
        repeatField.text=nil;
    }
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    pickerArray = [[NSMutableArray alloc] init];
    
    [pickerArray addObject:@"не повторять"];
    [pickerArray addObject:@"через минуту"];
    [pickerArray addObject:@"через час"];
    [pickerArray addObject:@"через день"];
    [pickerArray addObject:@"через неделю"];
    
    repeatField.delegate = self;
    

    


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
    if (self.notify && _edit == YES) {
        [self.notify setValue:self.nameField.text forKey:@"name"];
        

        if (notifyDate==nil) {
            [self.notify setValue:[self.notify valueForKey:@"date"] forKey:@"date"];
        }
        else {
        [self.notify setValue:notifyDate forKey:@"date"];
        }
        
        [self.notify setValue:self.repeatField.text forKey:@"repeat"];
    }
    else {
    NotifyData * notifyAdd = [NSEntityDescription insertNewObjectForEntityForName:@"NotifyData"
                                                     inManagedObjectContext:self.managedObjectContext];
    notifyAdd.name = self.nameField.text;
    [notifyAdd setValue:notifyDate forKey:@"date"];
    notifyAdd.repeat = self.repeatField.text;
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = notifyDate;
        localNotification.alertBody = self.nameField.text;
        localNotification.alertAction = @"Show me the item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        if ([repeatField.text isEqual: @"не повторять"]) {
            
            localNotification.repeatInterval = 0;
            
        }
        else if ([repeatField.text isEqual: @"через минуту"]) {
            
            localNotification.repeatInterval = NSCalendarUnitMinute;
        }
        else if ([repeatField.text isEqual: @"через час"]) {
            
            localNotification.repeatInterval = NSCalendarUnitHour;
        }
        else if ([repeatField.text isEqual: @"через день"]) {
            
            localNotification.repeatInterval = NSCalendarUnitDay;
        }
        else if ([repeatField.text isEqual: @"через неделю"]) {
            
            localNotification.repeatInterval = NSCalendarUnitWeekday;
        }
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    

    }
     NSError *error = nil;
     if (![self.managedObjectContext save:&error]){
         [self.view makeToast:(@"Ошибка: %@ %@", error, [error localizedDescription])
       duration:3.5
       position:CSToastPositionCenter];
     }
     else {
       [self.view makeToast:@"Напоминание добавлено"
       duration:3.0
       position:CSToastPositionCenter];
         // Dismiss the view controller
         [self performSelector:@selector(back) withObject:nil afterDelay:3.5];
         
     }
}

-(void)back {
    [repeatField resignFirstResponder];
    [nameField resignFirstResponder];
    [dateField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
