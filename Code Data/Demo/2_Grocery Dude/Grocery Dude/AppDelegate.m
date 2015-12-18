//
//  AppDelegate.m
//  Grocery Dude
//
//  Created by Tim Roadley on 18/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//

#import "AppDelegate.h"
#import "Item.h"

@implementation AppDelegate
#define debug 1

- (void)demo {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSArray *newItems = @[@"apples", @"rice", @"eggs", @"oranges"];
    for (NSString *newItemName in newItems) {
        Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:_coreDataHelper.context];
        newItem.name = newItemName;
        NSLog(@"Insert Item: %@", newItem.name);
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSArray *array = [_coreDataHelper.context executeFetchRequest:request error:nil];
    for (Item *item in array) {
        NSLog(@"name: %@", item.name);
    }
    

}

- (CoreDataHelper*)cdh {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (!_coreDataHelper) {
        _coreDataHelper = [CoreDataHelper new];
        [_coreDataHelper setupCoreData];
    }
    return _coreDataHelper;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[self cdh] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self cdh];
    [self demo];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[self cdh] saveContext];
}

@end
