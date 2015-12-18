//
//  AppDelegate.m
//  GroceryDude
//
//  Created by dllo on 15/12/1.
//  Copyright © 2015年 rain. All rights reserved.
//

#import "AppDelegate.h"
#import "Item.h"

/** P51 要求用Amount.h 替换 Measurement.h. */
//#import "Measurement.h"

/** P61 要求用Unit.h 替换 Amount.h. */
//#import "Amount.h"

#import "Unit.h"

#define debug 1



@interface AppDelegate ()

@end

@implementation AppDelegate

- (CoreDataHelper *)cdh
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!_coreDataHelper) {
        _coreDataHelper = [CoreDataHelper new];
        [_coreDataHelper setupCoreData];
    }
    return _coreDataHelper;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[self cdh] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
}



- (void)demo {
    
if (debug == 1) {
    
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
 
}
    
#pragma mark - 第三章

#pragma mark 3.5节 程序清单3-10 P61

#if 1
    
    /** */
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Unit"];
    [request setFetchLimit:50];
    NSError *error = nil;
    NSArray *fechedObjects = [_coreDataHelper.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", error);
    } else {
        for (Unit *unit in fechedObjects) {
            NSLog(@"Fetch Object = %@", unit.name);
        }
    }
    
#endif

    
    
#pragma mark 3.4 默认的迁移方式 

    
#if 0
    
    /** P48 - P51 具体操作步骤. */
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Amount"];
    [request setFetchLimit:50];
    NSError *error = nil;
    NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    } else {
        
        for (Amount *amount in fetchedObjects) {
            NSLog(@"Fetched Object = %@", amount.xyz);
        }
    }
    
    
#endif
    
    
    
#pragma mark  3.3 轻量级迁移方式.

#if 0

#pragma mark  *** 显示一部分数据.
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Measurement"];
    /** 限制取出的数量为50. */
    [request setFetchLimit:50];
    NSError *error = nil;
    NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", error);
    } else {
        for (Measurement *measurement in fetchedObjects) {
            NSLog(@"Fetched Object = %@", measurement.abc);
        }
    }
    
    
#endif
    

    
#pragma mark  *** 插入测试数据(为下一节做准备)
    
#if 0
    for (int i = 0; i < 5000; i++) {
        Measurement *newMeasurement = [NSEntityDescription insertNewObjectForEntityForName:@"Measurement" inManagedObjectContext:_coreDataHelper.context];
        newMeasurement.abc = [NSString stringWithFormat:@"-->> LOTS OF TEST DATA x%i", i];
        NSLog(@"Inserted %@", newMeasurement.abc);
    }
    
    [_coreDataHelper saveContext];
    
#endif
    
    


    
#pragma mark - 第二章 实体插入, 排序, 筛选, 删除

#if 0
    NSArray *newItemNames = @[@"Apples", @"Milk", @"Bread", @"Cheese", @"Sausages", @"Butter", @"Orange Juice", @"Cereal", @"Coffee", @"Eggs", @"Tomatoes", @"Fish"];
    
    for (NSString *newItemName in newItemNames) {
        Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:_coreDataHelper.context];
        newItem.name = newItemName;
        NSLog(@"Inserted New Managed Object for '%@'", newItem.name);
    }
    
    /** 代码创建获取请求. */
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    
    /** 根据模板创建请求. 如果要改变这种请求, 例如: 排序, 那么需要将它copy一份. */
//    NSFetchRequest *request = [[_coreDataHelper.model fetchRequestTemplateForName:@"Test"] copy];
//    
    /** 排序. */
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
//    [request setSortDescriptors:@[sort]];
    
//    /** 筛选. */
//    NSPredicate *filter = [NSPredicate predicateWithFormat:@"name != %@", @"Coffee"];
//    [request setPredicate:filter];

    
    NSArray *array = [_coreDataHelper.context executeFetchRequest:request error:nil];
    
    
    for (Item *item in array) {
        NSLog(@"Fetched Object: %@", item.name);
        
        [_coreDataHelper.context deleteObject:item];
        /** 在上下文中删除托管对象. */
        
    }
    
#endif

    
}
    
    
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self cdh];
    [self demo];
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[self cdh] saveContext];
    
}

@end
