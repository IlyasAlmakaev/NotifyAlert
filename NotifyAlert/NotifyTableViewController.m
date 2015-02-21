//
//  NotifyTableViewController.m
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//


#import "NotifyTableViewController.h"
#import "NotifyTableViewCell.h"
#import "NotifyNoDateTableViewCell.h"
#import "NotifyViewController.h"
// REVIEW Зачем?
#import "NotifyData.h"
#import "AppDelegate.h"
// REVIEW Зачем?

@interface NotifyTableViewController ()

@property (retain, nonatomic) NSMutableArray *notifications;

@end

@implementation NotifyTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = NSLocalizedString(@"Reminders", nil);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd                                                                                                                       target:self                                                                                                                       action:@selector(AddNotify)];
        // REVIEW Выровнять.
        // REVIEW Переименовать селектор с маленькой буквы (camelCase).
    }
    return self;
}

- (void)AddNotify
{
    self.notifyViewC.edit = NO;
    UINavigationController *navigationC = [[UINavigationController alloc] initWithRootViewController:self.notifyViewC];
    // REVIEW Почему бы не создать NavigationController один раз, например, в AppDelegate?
    [self.navigationController presentViewController:navigationC
                       animated:YES
                     completion:nil];
            // REVIEW Выровнять.
}

// Connect data function in Data Core
- (NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
    // REVIEW Гораздо лучше сразу в AppDelegate присвоить
    // REVIEW NSManagedObjectContext этому классу. Какой смысл
    // REVIEW при каждом действии с базой выполнять одно и то же?
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // REVIEW Зачем YES?
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52/255. green:52/255. blue:52/255. alpha:1];
    // REVIEW Разбить на строки.
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    // REVIEW Выполнять это ровно один раз. Какой смысл при каждом отображении
    // REVIEW выставлять старые значения?
    
    // Connect data base function
    NSManagedObjectContext *managedObjextContext = [self managedObjectContext];
    // Load data "NotifyData" in tableView
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"NotifyData"];
    self.notifications = [[managedObjextContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    // REVIEW Зачем?
    
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
    
    NSManagedObject *notification = [self.notifications objectAtIndex:indexPath.row];
    
    if ([notification valueForKey:@"date"] == nil) {
        tableView.rowHeight = 44;
        // REVIEW Заменить на использование tableView:heightForRowAtIndexPath:
        // REVIEW Получать высоту из XIB.
        NotifyNoDateTableViewCell *cellNoDate = [tableView dequeueReusableCellWithIdentifier:@"IdCellNoDate"];
        if (!cellNoDate) {
            [tableView registerNib:[UINib nibWithNibName:@"NotifyNoDateTableViewCell" bundle:nil] forCellReuseIdentifier:@"IdCellNoDate"];
            // REVIEW Перенести во viewDidLoad.
            cellNoDate = [tableView dequeueReusableCellWithIdentifier:@"IdCellNoDate"];
        }
        
        [cellNoDate.nameNoDateRemind setText:[notification valueForKey:@"name"]];
        // REVIEW Сделать у ячейки метод setup:(NSManagedObject *)notification
        // REVIEW Лишь в нём всё настраивать, ибо настройка ячейки - это дело
        // REVIEW ячейки, а не её родителя.
        
        return cellNoDate;
        
    }
    else {
        tableView.rowHeight = 64;
        // REVIEW Заменить на использование tableView:heightForRowAtIndexPath:
        // REVIEW Получать высоту из XIB.
        NotifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"NotifyTableViewCell" bundle:nil] forCellReuseIdentifier:@"IdCell"];
            // REVIEW Перенести во viewDidLoad.
            cell = [tableView dequeueReusableCellWithIdentifier:@"IdCell"];
        }
            
        // Configure the cell...
        
        [cell.nameRemind setText:[notification valueForKey:@"name"]];
        // DateFormat
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"HH:mm / dd.MM.yy"];
        NSString *string = [format stringFromDate:[notification valueForKey:@"date"]];
        // REVIEW Использовать timeRemind, ведь это та же переменная.
        [cell.dateRemind setText:string];
        
        if ([[notification valueForKey:@"repeat"]  isEqual: NSLocalizedString(@"Do not repeat", nil)] || [notification valueForKey:@"repeat"] == nil) {
            // REVIEW Использовать для значения 'repeat' лишь константу,
            // REVIEW НИКАК не связанную с отображением и localized string.
            cell.imageRepeat.hidden = true;
        }
        else
        {
            cell.imageRepeat.hidden = false;
        }
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* now = [NSDate date];
        NSDate *timeRemind = [notification valueForKey:@"date"];
        
        NSDateComponents *currentComps = [calendar components:( NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:now toDate:timeRemind options:0];
        //   NSDate *itemDate = [calendar dateFromComponents:currentComps];
        
        
        NSInteger days = [currentComps day];
        NSInteger hours = [currentComps hour];
        NSInteger minutes = [currentComps minute];
        
        NSString *dayString;
        NSString *iN = NSLocalizedString(@"In", nil);
        NSString *d = NSLocalizedString(@"d.", nil);
        NSString *h = NSLocalizedString(@"h.", nil);
        NSString *m = NSLocalizedString(@"min.", nil);
        
        if (days > 0) {
                dayString = [NSString stringWithFormat:@"%@ %ld %@ %ld %@ %ld %@", iN, (long)days, d, (long)hours, h, (long)minutes, m];
        }
        
        if (days <= 0)
            dayString = [NSString stringWithFormat:@"%@ %ld %@ %ld %@", iN, (long)hours, h, (long)minutes, m];
        
        if (hours <= 0)
            dayString = [NSString stringWithFormat:@"%@ %ld %@", iN, (long)minutes, m];
        
        if (minutes <= 0)
            dayString = [NSString stringWithFormat:NSLocalizedString(@"No time", nil)];
        
        [cell.timerRemind setText:dayString];
        // REVIEW Сделать у ячейки метод setup:(NSManagedObject *)notification
        // REVIEW Лишь в нём всё настраивать, ибо настройка ячейки - это дело
        // REVIEW ячейки, а не её родителя.
        
        return cell;
        
    }
    
    
    // REVIEW Убрать везде лишние пустые строки.
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
        // Delete local notification
        NSString *notificationName = [[self.notifications objectAtIndex:indexPath.row] valueForKey:@"name"];
        NSArray *localNotifications = [[UIApplication sharedApplication]  scheduledLocalNotifications];
        for(UILocalNotification *localNotification in localNotifications) {
            if ([localNotification.alertBody isEqualToString:notificationName])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
        // REVIEW Ни в коем случае нельзя НЕЯВНО использовать Application.
        // REVIEW Необходимо создать новый протокол для удаления notification.
        // REVIEW Этот протокол должен реализовать AppDelegate, который имеет
        // REVIEW полный доступ к Application. NotifyTVC лишь должен принимать
        // REVIEW делагата, реализующего протокол и вызывать метод делегата.
        // Delete the row from the data source
        [context deleteObject:[self.notifications objectAtIndex:indexPath.row]];
        NSString *notDelete = NSLocalizedString(@"Can't Delete!", nil);
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"%@ %@ %@", notDelete, error, [error localizedDescription]);
            // REVIEW Выводить с помощью Toast ошибку удаления.
            // REVIEW Также не ясно, что если удалится уведомление,
            // REVIEW но не удалится запись в базе?
            return;
        }
        [self.notifications removeObjectAtIndex:indexPath.row];
    
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        // REVIEW Опять же нельзя НЕЯВНО использовать Application.
        // REVIEW Поможет делегат.
        [self.tableView reloadData];
        // REVIEW Точно ли это нужно? Ведь уже выше происходит deleteRowsAtIndexPaths.
        // REVIEW Разве этого не достаточно?
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
    // REVIEW Почему бы не создать NavigationController один раз, например, в AppDelegate?
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
