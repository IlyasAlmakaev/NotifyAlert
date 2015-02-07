//
//  NotifyTableViewController.m
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//


#import "NotifyTableViewController.h"
#import "NotifyTableViewCell.h"
#import "NotifyViewController.h"
#import "NotifyData.h"
#import "AppDelegate.h"

@interface NotifyTableViewController ()

@property (retain, nonatomic) NSMutableArray *notifications;

@end

@implementation NotifyTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"Напоминание";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd                                                                                                                       target:self                                                                                                                       action:@selector(AddNotify)];
    }
    return self;
}

- (void)AddNotify
{
    self.notifyViewC.edit = NO;
    UINavigationController *navigationC = [[UINavigationController alloc] initWithRootViewController:self.notifyViewC];
    [self.navigationController presentViewController:navigationC
                       animated:YES
                     completion:nil];
}

// Connect data function in Data Core
- (NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // Connect data base function
    NSManagedObjectContext *managedObjextContext = [self managedObjectContext];
    // Load data "NotifyData" in tableView
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"NotifyData"];
    self.notifications = [[managedObjextContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.notifications.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"NotifyTableViewCell" bundle:nil] forCellReuseIdentifier:@"IdCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"IdCell"];
    }
    // Configure the cell...
    
    NSManagedObject *notification = [self.notifications objectAtIndex:indexPath.row];
    
    [cell.nameRemind setText:[notification valueForKey:@"name"]];
    // DateFormat
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *string = [format stringFromDate:[notification valueForKey:@"date"]];
    [cell.dateRemind setText:string];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* now = [NSDate date];
    NSDate *timeRemind = [notification valueForKey:@"date"];
    
    NSDateComponents *currentComps = [calendar components:( NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:now toDate:timeRemind options:0];
 //   NSDate *itemDate = [calendar dateFromComponents:currentComps];
    
 
    NSInteger days = [currentComps day];
    NSInteger hours = [currentComps hour];
    NSInteger minutes = [currentComps minute];
    
    NSString *dayString;
    
    if (days > 0) {
        if (days == 1) {
                    dayString = [NSString stringWithFormat:@"Завтра через %ld ч. %ld мин.", (long)hours, (long)minutes];
        }
        else if (days == 2) {
            dayString = [NSString stringWithFormat:@"Послезавтра через %ld ч. %ld мин.", (long)hours, (long)minutes];
        }
        else  {
            dayString = [NSString stringWithFormat:@"Через %ld дн. %ld ч. %ld мин.", (long)days, (long)hours, (long)minutes];
        }
    }
    
    if (days <= 0)
        dayString = [NSString stringWithFormat:@"Через %ld ч. %ld мин.", (long)hours, (long)minutes];
    
    if (hours <= 0)
        dayString = [NSString stringWithFormat:@"Через %ld мин.", (long)minutes];
    
    if (minutes <= 0)
        dayString = [NSString stringWithFormat:@"Время истекло"];
    


    

    

    
    
    

    
  /*  NSTimeInterval differenceInDays =
    [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:now] -
    [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:timeRemind];
    
    NSString *dayString;
    NSDate *calculateDate = [[NSDate alloc] initWithTimeIntervalSinceNow:differenceInDays];

            NSDateFormatter* dayFormatter = [[NSDateFormatter alloc] init];
      //      [dayFormatter setLocale:NSLocale];
            [dayFormatter setDateFormat:@"HH:mm"];
            dayString = [dayFormatter stringFromDate: calculateDate];*/
   /* NSDateFormatter* dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"dd HH:mm"];
NSString *stringTime = [dayFormatter stringFromDate:itemDate];*/
    
    [cell.timerRemind setText:dayString];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [context deleteObject:[self.notifications objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        [self.notifications removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self.tableView reloadData];
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.notifyViewC.edit = YES;
    self.notifyViewC.notify = [self.notifications objectAtIndex:indexPath.row];
    UINavigationController *navigationC = [[UINavigationController alloc] initWithRootViewController:self.notifyViewC];
    [self.navigationController presentViewController:navigationC
                                            animated:YES
                                          completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
