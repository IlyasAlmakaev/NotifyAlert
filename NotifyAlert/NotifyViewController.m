//
//  NotifyViewController.m
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "NotifyViewController.h"
#import "NotifyData.h"
#import "DisableTextFieldEdit.h"
#import "Common.h"


@interface NotifyViewController ()
<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

    @property (strong, nonatomic) Common *com;
    @property (strong, nonatomic) AppDelegate *appD;
    @property (strong, nonatomic) UIPickerView *pickerView;
    @property (strong, nonatomic) UIDatePicker *datePickerView;
    @property (strong, nonatomic) NSMutableArray *repeatOptions;
    @property (strong, nonatomic) NSDate *notifyDate;
    @property (strong, nonatomic) NSString *dateF, *repeatF, *nilString;

    @property (weak, nonatomic) IBOutlet UITextField *nameField;
    @property (weak, nonatomic) IBOutlet DisableTextFieldEdit *dateField;
    @property (weak, nonatomic) IBOutlet DisableTextFieldEdit *repeatField;
    @property (weak, nonatomic) IBOutlet UISwitch *switcher;

    - (IBAction)switcherPressed:(id)sender;

@end

@implementation NotifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.title = NSLocalizedString(@"View_Title", nil);

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(back)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(save)];
        
        self.dateF = NSLocalizedString(@"DateField_PlaceHolder", nil);
        self.repeatF = NSLocalizedString(@"RepeatField_PlaceHolder", nil);
        self.notRepeat = NSLocalizedString(@"RepeatOption_DoNotRepeat", nil);
        self.everyMinute = NSLocalizedString(@"RepeatOption_EveryMinute", nil);
        self.everyHour = NSLocalizedString(@"RepeatOption_EveryHour", nil);
        self.everyDay = NSLocalizedString(@"RepeatOption_EveryDay", nil);
        self.everyWeek = NSLocalizedString(@"RepeatOption_EveryWeek", nil);
        self.nilString = @"";
        
        // Create Array for PickerView
        self.repeatOptions = [[NSMutableArray alloc] init];
        [self.repeatOptions addObject:self.notRepeat];
        [self.repeatOptions addObject:self.everyMinute];
        [self.repeatOptions addObject:self.everyHour];
        [self.repeatOptions addObject:self.everyDay];
        [self.repeatOptions addObject:self.everyWeek];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Show PickerView
    CGRect pickerFrame = CGRectZero;

    self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];

    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;

    // Show DatePickerView
    CGRect datePickerFrame = CGRectZero;
    self.datePickerView = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    [self.datePickerView setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.datePickerView setMinimumDate:[NSDate date]];
    
    self.nameField.placeholder = NSLocalizedString(@"NameField_PlaceHolder", nil);
    self.repeatField.delegate = self;
    
    self.appD = [[AppDelegate alloc] init];
    self.com = [[Common alloc] init];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.

    BOOL indicator;
    
    if (self.edit)
    {
        indicator = YES;
        
        [self.nameField setText:[self.notify valueForKey:@"name"]];
        [self dateFormatter:[self.notify valueForKey:@"date"]];
        
        if ([self.notify valueForKey:@"date"] != nil && [self.notify valueForKey:@"repeat"] != nil)
        [self.datePickerView setDate:[self.notify valueForKey:@"date"]];
        
        self.notifyDate = [self.notify valueForKey:@"date"];
        [self.repeatField setText:[self.notify valueForKey:@"repeat"]];
        self.repeatField.placeholder = nil;
        
        if ([self.notify valueForKey:@"date"] == nil && [self.notify valueForKey:@"repeat"] == nil)
        {
            indicator = NO;
            
            self.dateField.text = nil;
            self.repeatField.text = nil;
            self.dateField.placeholder = self.dateF;
            self.repeatField.placeholder = self.repeatF;
            
            NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
            [usrDefaults setInteger:0 forKey:@"Index"];
        }
    }
    else
    {
        indicator = NO;
        
        self.dateField.text = nil;
        self.repeatField.text = nil;
        self.dateField.placeholder = self.dateF;
        self.repeatField.placeholder = self.repeatF;
        self.nameField.text=nil;
        
        NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
        [usrDefaults setInteger:0 forKey:@"Index"];
    }
    self.switcher.on = indicator;
    self.dateField.enabled = indicator;
    self.repeatField.enabled = indicator;
}

- (IBAction)switcherPressed:(id)sender
{
    BOOL indicator;
    if (self.switcher.on)
    {
        indicator = YES;
        
        [self dateFormatter:[NSDate date]];
        self.notifyDate = [NSDate date];
        self.repeatField.text = nil;
        self.repeatField.placeholder = [self.repeatOptions objectAtIndex:0];
        [self.datePickerView setDate:[NSDate date]];
    }
    else
    {
        indicator = NO;
        
        self.dateField.text = nil;
        self.repeatField.text = nil;
        self.dateField.placeholder = self.dateF;
        self.repeatField.placeholder = self.repeatF;
    }
    
    self.dateField.enabled = indicator;
    self.repeatField.enabled = indicator;
}

    // Hide Keyboard/DateBoard/RepeatOptions
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

    // Block text for repeatField and dateField
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

    // Shake textField-method
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake)
        self.nameField.text=nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.repeatField)
    {
        if ([self.repeatField.text isEqual: self.notRepeat] || self.repeatField.placeholder == [self.repeatOptions objectAtIndex:0])
        {
            self.repeatField.placeholder = nil;
            self.repeatField.text = self.notRepeat;
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
        }
        else if ([self.repeatField.text isEqual: self.everyMinute])
            [self.pickerView selectRow:1 inComponent:0 animated:NO];
        
        else if ([self.repeatField.text isEqual: self.everyHour])
            [self.pickerView selectRow:2 inComponent:0 animated:NO];
        
        else if ([self.repeatField.text isEqual: self.everyDay])
            [self.pickerView selectRow:3 inComponent:0 animated:NO];
        
        else if ([self.repeatField.text isEqual: self.everyWeek])
            [self.pickerView selectRow:4 inComponent:0 animated:NO];

        self.repeatField.inputView = self.pickerView;
    }
    else if (textField == self.dateField)
    {
        self.notifyDate = [self.datePickerView date];
        [self dateFormatter:self.notifyDate];
        
        self.dateField.inputView = self.datePickerView;
        
        [self.datePickerView addTarget:self action:@selector(didChangeDate:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)didChangeDate:(id)sender
{
    self.notifyDate = [self.datePickerView date];
    [self dateFormatter:self.notifyDate];
}

    // DateFormat to string
- (void)dateFormatter:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm / dd.MM.yy"];
    [self.dateField setText:[format stringFromDate:date]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.repeatOptions.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.repeatOptions objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.repeatField.text = [self.repeatOptions objectAtIndex:row];
}

// Add/Edit notification
- (void)save
{
    NSString *ErrorString = NSLocalizedString(@"View_Error", nil);
    // Not empty field
    if (self.nameField.text && self.nameField.text.length > 0 && [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length!=0)
    {
        // Switch on
        if (self.switcher.on)
        {
            // Edit notification
            if (self.notify && self.edit == YES)
            {
                NSDate *notificationDate = [self.notify valueForKey:@"date"];
                NSString *notificationName = [self.notify valueForKey:@"name"];
                
                [self.appD deleteNotification:notificationDate name:notificationName];

                [self.notify setValue:self.nameField.text forKey:@"name"];
                [self.notify setValue:self.notifyDate forKey:@"date"];
                
                if ([self.repeatField.text isEqual:self.nilString])
                    [self.notify setValue:self.repeatField.placeholder forKey:@"repeat"];
                
                else
                    [self.notify setValue:self.repeatField.text forKey:@"repeat"];
            }
            // Add new notification
            else
            {
                NotifyData * notifyAdd = [NSEntityDescription insertNewObjectForEntityForName:@"NotifyData"
                                                                       inManagedObjectContext:self.appD.managedOC];
                
                notifyAdd.name = self.nameField.text;
                [notifyAdd setValue:self.notifyDate forKey:@"date"];
                
                if ([self.repeatField.text isEqual:self.nilString])
                    notifyAdd.repeat = self.repeatField.placeholder;
                
                else
                    notifyAdd.repeat = self.repeatField.text;
            }
            
            NSError *error = nil;
            NSString *text = [NSString stringWithFormat:@"%@: %@ %@", ErrorString, error, [error localizedDescription]];
            // Check error
            if (![self.appD.managedOC save:&error])
                [self.com showToast:text view:self];
            
            else
                // register Notification
                [self.appD dateField: self.notifyDate nameField: self.nameField.text repeatField: self.repeatField.text];
        }
        // Switch off
        else
        {
            // Edit notification
            if (self.notify && self.edit == YES)
            {
                [self.notify setValue:self.nameField.text forKey:@"name"];
                [self.notify setValue:nil forKey:@"date"];
                [self.notify setValue:nil forKey:@"repeat"];
                
                // Delete local notification
                NSDate *notificationDate = [self.notify valueForKey:@"date"];
                NSString *notificationName = [self.notify valueForKey:@"name"];
                
                [self.appD deleteNotification:notificationDate name:notificationName];
                
                NSError *error = nil;
                NSString *text = [NSString stringWithFormat:@"%@: %@ %@", ErrorString, error, [error localizedDescription]];
                
                // Check error
                if (![self.appD.managedOC save:&error])
                    [self.com showToast:text view:self];
            }
            // Add new notification
            else
            {
                NotifyData *notifyAdd = [NSEntityDescription insertNewObjectForEntityForName:@"NotifyData"
                                                                      inManagedObjectContext:self.appD.managedOC];
                notifyAdd.name = self.nameField.text;
                
                NSError *error = nil;
                NSString *text = [NSString stringWithFormat:@"%@: %@ %@", ErrorString, error, [error localizedDescription]];
                // Check error
                if (![self.appD.managedOC save:&error])
                    [self.com showToast:text view:self];
            }
        }
        
        // Dismiss the view controller
        [self performSelector:@selector(back) withObject:nil];
    }
    else
        [self.com showToast:NSLocalizedString(@"Toast_EmptyNameField", nil) view:self];
}

// Exit
- (void)back
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
