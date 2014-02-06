//
//  MGKAppDelegate.m
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "MGKAppDelegate.h"

@implementation MGKAppDelegate

//@synthesize managedObjectContext;
//@synthesize managedObjectModel;
//@synthesize persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //self.window.tintColor = [UIColor blueColor];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//
//// Core data
//- (void)saveContext
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil)
//    {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
//        {
//            /*
//             Replace this implementation with code to handle the error appropriately.
//             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//             */
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}
//- (NSURL *)applicationDocumentsDirectory
//{
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectoryinDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectContext *)managedObjectContext
//{
//    if (managedObjectContext != nil)
//    {
//        return managedObjectContext;
//    }
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil)
//    {
//        managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return managedObjectContext;
//}
///**
// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
// */
//- (NSManagedObjectModel *)managedObjectModel
//{
//    if (managedObjectModel != nil)
//    {
//        return managedObjectModel;
//    }
//    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
//    return managedObjectModel;
//}
///**
// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
// */
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (persistentStoreCoordinator != nil)
//    {
//        return persistentStoreCoordinator;
//    }
//    NSURL *storeURL = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"CoreDataTabBarTutorial.sqlite"];
//    NSError *error = nil;
//    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[selfmanagedObjectModel]];
//    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURLoptions:nil error:&error])
//    {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    return persistentStoreCoordinator;
//}

@end
