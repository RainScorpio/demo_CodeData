//
//  CoreDataHelper.h
//  CoreData_GroceryDude
//
//  Created by dllo on 15/11/25.
//  Copyright © 2015年 rain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MigrationVC.h"

@interface CoreDataHelper : NSObject

#pragma mark - 第一章
@property (nonatomic, readonly) NSManagedObjectContext *context; /** 托管对象上下文. */
@property (nonatomic, readonly) NSManagedObjectModel *model; /** 托管对象模型. */
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator; /** 持久化存储协调器. */
@property (nonatomic, readonly) NSPersistentStore *store; /** 持久化存储区. */

- (void)setupCoreData; /** 创建CoreDataHelper实例时, 调用此方法. */
- (void)saveContext; /** 将托管对象上下文里发生的变更存储到持久化存储区. (在AppDelegate.m文件的代理方法里调用.)*/


#pragma mark - 第三章
#pragma mark 3.5节  P54

@property (nonatomic, retain) MigrationVC *migrationVC;
/** 在.m文件中添加*/

@end
