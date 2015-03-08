//
//  NotifyTableViewController.m
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "Common.h"
#import "NotifyTableViewController.h"
#import "NotifyTableViewCell.h"
// REVIEW Зачем?
// ANSWER Убрал
#import "NotifyData.h"
#import "AppDelegate.h"
// REVIEW Зачем?
// ANSWER Для связи с NSManagedObject, функцией удаления.


@interface NotifyTableViewController ()

@property (retain, nonatomic) NSMutableArray *notifications;
@property (strong, nonatomic) Common *com;

@end

@implementation NotifyTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.title = NSLocalizedString(@"TableView_Title", nil);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                               target:self
                                                                                               action:@selector(addNotify)];
        // REVIEW Выровнять.
        // REVIEW Переименовать селектор с маленькой буквы (camelCase).
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appD = [[AppDelegate alloc] init];
    self.com = [[Common alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    // REVIEW Зачем?
    // ANSWER Чтобы убрать разделительные линии, где нет ячеек.
    [self.tableView registerNib:[UINib nibWithNibName:@"NotifyTableViewCell" bundle:nil] forCellReuseIdentifier:@"IdCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // REVIEW Зачем YES?
    // ANSWER Исправил.

    // REVIEW Выполнять это ровно один раз. Какой смысл при каждом отображении
    // REVIEW выставлять старые значения?
    // ANSWER Исправил.
    
    // Load data "NotifyData" in tableView
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"NotifyData"];
    self.notifications = [[self.appD.managedOCTable executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.appD addObject:[self.notifications objectAtIndex:indexPath.row]
              controller:self
                testBool:YES];
}
    // REVIEW Гораздо лучше сразу в AppDelegate присвоить
    // REVIEW NSManagedObjectContext этому классу. Какой смысл
    // REVIEW при каждом действии с базой выполнять одно и то же?
    // ANSWER Исправил.


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSManagedObject *notification = [self.notifications objectAtIndex:indexPath.row];
        // REVIEW Заменить на использование tableView:heightForRowAtIndexPath:
        // REVIEW Получать высоту из XIB.
        // ANSWER Оставил одну ячейку стандартного размера.
        NotifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdCell"];
        [cell setup:notification];
        // REVIEW Сделать у ячейки метод setup:(NSManagedObject *)notification
        // REVIEW Лишь в нём всё настраивать, ибо настройка ячейки - это дело
        // REVIEW ячейки, а не её родителя.
        // ANSWER Исправил
        return cell;
        // REVIEW Убрать везде лишние пустые строки.
        // ANSWER Убрал.
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete local notification
        NSDate *notificationDate = [[self.notifications objectAtIndex:indexPath.row] valueForKey:@"date"];
        NSString *notificationName = [[self.notifications objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        [self.appD deleteNotification:notificationDate name:notificationName];
        // REVIEW Ни в коем случае нельзя НЕЯВНО использовать Application.
        // REVIEW Необходимо создать новый протокол для удаления notification.
        // REVIEW Этот протокол должен реализовать AppDelegate, который имеет
        // REVIEW полный доступ к Application. NotifyTVC лишь должен принимать
        // REVIEW делагата, реализующего протокол и вызывать метод делегата.
        // ANSWER Создал.
        
        // Delete the row from the data source
        [self.appD.managedOCTable deleteObject:[self.notifications objectAtIndex:indexPath.row]];
        
        NSString *notDelete = NSLocalizedString(@"TableView_Error", nil);
        NSError *error = nil;
        
        if (![self.appD.managedOCTable save:&error])
        {
            [self.com showToast:(@"%@ %@ %@", notDelete, error, [error localizedDescription]) view:self];
            // REVIEW Выводить с помощью Toast ошибку удаления.
            // REVIEW Также не ясно, что если удалится уведомление,
            // REVIEW но не удалится запись в базе?
            // ANSWER Исправил.
            return;
        }
        
        [self.notifications removeObjectAtIndex:indexPath.row];
        
        if (![self.appD.managedOCTable save:&error])
        {
            [self.com showToast:(@"%@ %@ %@", notDelete, error, [error localizedDescription]) view:self];
            return;
        }
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // REVIEW Опять же нельзя НЕЯВНО использовать Application.
        // REVIEW Поможет делегат.
        // ANSWER Убрал из-за ненадобности.
        
        // REVIEW Точно ли это нужно? Ведь уже выше происходит deleteRowsAtIndexPaths.
        // REVIEW Разве этого не достаточно?
        // ANSWER Убрал. Это было нужно когда отображались два типа ячеек c разными размерами.
        // ANSWER Т.к. при удалении ячейки без обновления table, некорректно отображались ячейки в table.
    }
}

- (void)addNotify
{
    // REVIEW Почему бы не создать NavigationController один раз, например, в AppDelegate?
    // ANSWER Создал.

    // REVIEW Выровнять.
    [self.appD addObject:nil
              controller:self
                testBool:NO];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
