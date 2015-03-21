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
#import "NotifyData.h"
#import "AppDelegate.h"


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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appD = [[AppDelegate alloc] init];
    self.com = [[Common alloc] init];
    
    // Hide table separator
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NotifyTableViewCell" bundle:nil] forCellReuseIdentifier:@"IdCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load data "NotifyData" in tableView
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"NotifyData"];
    self.notifications = [[self.appD.managedOCTable executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Edit notification and go to NotifyViewController
    [self.appD addObject:[self.notifications objectAtIndex:indexPath.row]
              controller:self
                testBool:YES];
}

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

        NotifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdCell"];
    
        // Add cell
        [cell setup:notification];

        return cell;
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
        
        // Delete the row from the data source
        [self.appD.managedOCTable deleteObject:[self.notifications objectAtIndex:indexPath.row]];
        
        NSString *notDelete = NSLocalizedString(@"TableView_Error", nil);
        NSError *error = nil;
        NSString *text = [NSString stringWithFormat:@"%@ %@ %@", notDelete, error, [error localizedDescription]];
        // Check error
        if (![self.appD.managedOCTable save:&error])
        {
            
            [self.com showToast:text view:self];

            return;
        }
        
        [self.notifications removeObjectAtIndex:indexPath.row];
        
        // Check error
        if (![self.appD.managedOCTable save:&error])
        {
            [self.com showToast:text view:self];
            return;
        }
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

    // Go to NotifyViewController
- (void)addNotify
{
    [self.appD addObject:nil
              controller:self
                testBool:NO];
}

@end
