//
//  AppDelegate.m
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "NotifyTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.testing.NotifyAlert" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NotifyAlert" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NotifyAlert.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification)
        // REVIEW Зачем {, если ровно один вызов после условия?
    application.applicationIconBadgeNumber = 0;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NotifyTableViewController *notifyTableViewC = [[NotifyTableViewController alloc] init];
 //   notifyTableViewC.notifyViewC = [[NotifyViewController alloc] init];
    // REVIEW Почему бы сразу сюда не присвоить [[NotifyViewController alloc] init]?
    // ANSWER Присвоил.
    UINavigationController *navigationC = [[UINavigationController alloc] initWithRootViewController:notifyTableViewC];
    navigationC.navigationBar.barTintColor = [UIColor colorWithRed:52/255.
                                                             green:52/255.
                                                              blue:52/255.
                                                                alpha:1];
    navigationC.navigationBar.barStyle = UIStatusBarStyleLightContent;
    navigationC.navigationBar.tintColor = [UIColor whiteColor];
    navigationC.navigationBar.translucent = NO;

    self.window.rootViewController = navigationC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dateField:(NSDate *)dateNotify nameField:(NSString *)nameNotify repeatField:(NSString *)repeatNotify
{
    NotifyViewController *notifyViewC = [[NotifyViewController alloc] init];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = dateNotify;
    localNotification.alertBody = nameNotify;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    if ([repeatNotify isEqual: notifyViewC.notRepeat])
        // REVIEW Опять же использовать переменную,
        // REVIEW никак не связанную с отображением.
        // ANSWER Исправил.
        localNotification.repeatInterval = 0;
    
    else if ([repeatNotify isEqual: notifyViewC.everyMinute])
        localNotification.repeatInterval = NSCalendarUnitMinute;

    else if ([repeatNotify isEqual: notifyViewC.everyHour])
        localNotification.repeatInterval = NSCalendarUnitHour;
    
    else if ([repeatNotify isEqual: notifyViewC.everyDay])
        localNotification.repeatInterval = NSCalendarUnitDay;

    else if ([repeatNotify isEqual: notifyViewC.everyWeek])
        localNotification.repeatInterval = NSCalendarUnitWeekday;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (NSManagedObjectContext *)managedOC
{
    NotifyViewController *notifyViewC = [[NotifyViewController alloc] init];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    notifyViewC.managedObjectContext = appDelegate.managedObjectContext;
    
    return notifyViewC.managedObjectContext;
}

- (NSManagedObjectContext *)managedOCTable
{
    NotifyTableViewController *notifyTalbeViewC = [[NotifyTableViewController alloc] init];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    notifyTalbeViewC.managedObjectContext = appDelegate.managedObjectContext;
    
    return notifyTalbeViewC.managedObjectContext;
}

- (void)addObject:(NSManagedObject *)managedObject controller:(UITableViewController *)tableVC testBool:(BOOL)boolValue
{
    NotifyViewController *notifyViewC = [[NotifyViewController alloc] init];
    
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:notifyViewC];
    navigationVC.navigationBar.barTintColor = [UIColor colorWithRed:52/255.
                                                              green:52/255.
                                                               blue:52/255.
                                                              alpha:1];
    navigationVC.navigationBar.barStyle = UIStatusBarStyleLightContent;
    navigationVC.navigationBar.tintColor = [UIColor whiteColor];
    navigationVC.navigationBar.translucent = NO;
    
    notifyViewC.edit = boolValue;
    notifyViewC.notify = managedObject;
    
    [tableVC.navigationController presentViewController:navigationVC
                                                        animated:YES
                                                      completion:nil];
}

- (void)deleteNotification:(NSDate *)notificationDate name:(NSString *)notificationName
{
    self.localNotifications = [[UIApplication sharedApplication]  scheduledLocalNotifications];
    
    for (UILocalNotification *localNotification in self.localNotifications)
    {
        NSComparisonResult result = [localNotification.fireDate compare:notificationDate];
        if (result == NSOrderedSame && [localNotification.alertBody isEqualToString:notificationName])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
// REVIEW В одних случаях { на отдельной строке, в других на той же. Необходимо
// REVIEW выбрать ОДИН вариант и придерживаться его. Должно быть постоянство.
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AppDelegate_Notification", nil)
                                                        message:notification.alertBody
                                                       delegate:self
                                              cancelButtonTitle:nil
            // REVIEW Почему cancelButtonTitle: не на отдельной строке?
                                              otherButtonTitles:nil];
        [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:)
                            withObject:nil
                            afterDelay:2.0];
        // REVIEW Это для того, чтобы заменить Toast?
        // REVIEW Если так, то нужно использовать Toast.
        // REVIEW Если нет, то надо объяснить.
        [alert show];
    }
    // REVIEW Зачем?
    // ANSWER Убрал. Но в начальной версии приложения это было
    // ANSWER нужно для обновления данных в TableView,
    // ANSWER которые создавались из localNotification, а теперь создаются из CoreData
    
    // Clear icon when show notification in open application
    // REVIEW В чём смысл этого комментария? Ведь это ясно из вызова.
    // REVIEW Гораздо лучше объяснить, зачем это делается.
    // ANSWER Объяснил
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

@end
