//
//  AppDelegate.h
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSArray *localNotifications;
- (void)deleteNotification:(NSDate *)notificationDate name:(NSString *)notificationName;

- (void)addObject:(NSManagedObject *)managedObject
       controller:(UITableViewController *)tableVC
         testBool:(BOOL)boolValue;

- (void)dateField:(NSDate *)dateNotify
        nameField:(NSString *)nameNotify
      repeatField:(NSString *)repeatNotify;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSManagedObjectContext *)managedOC;
- (NSManagedObjectContext *)managedOCTable;



@end

