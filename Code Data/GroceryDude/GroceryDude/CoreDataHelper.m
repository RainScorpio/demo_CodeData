//
//  CoreDataHelper.m
//  CoreData_GroceryDude
//
//  Created by dllo on 15/11/25.
//  Copyright © 2015年 rain. All rights reserved.
//

#import "CoreDataHelper.h"


@interface CoreDataHelper ()



@end

@implementation CoreDataHelper

#pragma mark - 第一章

#pragma mark  FILES

/** 为了协助调试功能而设. */
int const debug = 1;



/** 持久化存储区文件名. */
 NSString *storeFilename = @"Grocery-Dude.sqlite";

#pragma mark  PATHS
/** 为了找到持久化存储文件在文件系统中的位置. */

/** 返回应用程序文档目录的路径. */
- (NSString *)applicationDocumentsDirectory {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


/** 向应用程序文档目录添加Store目录的子目录, 并返回一个NSURL. 若Store目录不存在, 就创建一个. */
- (NSURL *)applicationStoresDirectory {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSURL *storesDirectory = [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]] URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            if (debug == 1) {
                NSLog(@"Successfully created Stores directory");
            } else {
                NSLog(@"FAILED to create Stores directory: %@", error);
            }
        }
        
    }
    
    return storesDirectory;
}

- (NSURL *)storeURL
{
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [[self applicationStoresDirectory] URLByAppendingPathComponent:storeFilename];
}

#pragma mark  SETUP

- (instancetype)init {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
    
    return self;
}

- (void)loadStore {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (_store) {
        return;
    }
    
    
    
#pragma mark - 第二章 2.12节 P32
    
#if 0
    NSDictionary *options = @{NSSQLitePragmasOption : @{@"journal_mode": @"DELETE"}};
#endif
    
#pragma mark - 第三章
#pragma mark 3.3节 程序清单3-1 P45
#if 0
    
    NSDictionary *options =
    @{
      NSMigratePersistentStoresAutomaticallyOption: @YES,
      NSInferMappingModelAutomaticallyOption: @YES,
      NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}};
#endif
    
#pragma mark 3.4节 P48
#if 0
    NSDictionary *options =
    @{
      NSMigratePersistentStoresAutomaticallyOption: @YES,
      NSInferMappingModelAutomaticallyOption: @NO,
      NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}};
#endif
    
#if 0
    /** 前面几节的公共部分代码. */
    NSError *error = nil;
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:options error:&error];
    
    if (!_store) {
        NSLog(@"Failed to add store. Error: %@", error);
    } else {
        if (debug == 1) {
            NSLog(@"Successfully added store: %@", _store);
        }
    }
#endif
    
#pragma mark 3.5节 程序清单3-9 P59
#if 1
    BOOL useMigrationManager = YES;
    
    if (useMigrationManager && [self ismigrationNecessaryForStore:[self storeURL]]) {
        [self performBackgroundManagedMigrationForStore:[self storeURL]];
    } else {
        NSDictionary *options = @{
                                  NSMigratePersistentStoresAutomaticallyOption: @YES,
                                  NSInferMappingModelAutomaticallyOption: @NO,
                                  NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}
                                  };
        
        NSError *error = nil;
        _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:options error:&error];
        
        if (!_store) {
            NSLog(@"Failed to add store. Error: %@", error);
        } else {
            if (debug == 1) {
                NSLog(@"Successfully added store: %@", _store);
            }
        }
        
    }
    
#endif
    
    
    
    
}



- (void)setupCoreData {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self loadStore];
    
}

#pragma mark  SAVING

- (void)saveContext {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if ([_context hasChanges]) {
        
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"_context SAVED changes to persistent store");
        } else {
            NSLog(@"Failed to save _contex: %@", error);
        }
        
    } else {
        NSLog(@"SKIPPED _context save, there are no changes!");
    }
    
    NSLog(@"path: %@", [self storeURL]);

}

#pragma mark - 第三章 
#pragma mark  3.5节 
#pragma mark  判断数据是否需要迁移 程序清单3-5 P55

/** 首先检查系统内是否有存储区, 如果有就判断新模型是否与现有的存储区相兼容. 详见P54最下面的一段话. */
- (BOOL)ismigrationNecessaryForStore:(NSURL *)storeUrl {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self storeURL].path]) {
        if (debug == 1) {
            NSLog(@"SKIPPED MIGRATION: Soure database missing.");
            return NO;
        }
    }
    
    /** 书上方法在iOS9中已弃用, 改为下面的方法. */
    NSDictionary *sourceMetadata = [self.coordinator metadataForPersistentStore:_store];
    
    NSManagedObjectModel *destinationModel = _coordinator.managedObjectModel;
    
    /** */
    if ([destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata]) {
        if (debug == 1) {
            NSLog(@"SKIPPED MIGRATION: Soure is already compatible.");
        }
        return NO;
    }
    
    
    return YES;
}

#pragma mark 迁移数据 程序清单3-6 P55
- (BOOL)migrateStore:(NSURL *)sourceStore {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    BOOL success = NO;
    NSError *error = nil;
    
    /** 步骤一: 用于收集执行数据迁移所需的信息. */
    
    /** 获取元数据. */
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:sourceStore options:nil error:&error];
    
    /** 元模型. */
    NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
    
    /** 目标模型. */
    NSManagedObjectModel *destinModel = _model;
    
    /** 映射模型. */
    NSMappingModel *mappingModel = [NSMappingModel mappingModelFromBundles:nil forSourceModel:sourceModel destinationModel:destinModel];
    
    /** 步骤二: 实际的迁移过程. */
    if (mappingModel) {
        NSError *error = nil;
        /** 初始化迁移管理器. */
        NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:destinModel];
        
        /** migrationProgress 是 NSMigrationManager的属性, 代表迁移进度. */
        [migrationManager addObserver:self forKeyPath:@"migrationProgress" options:NSKeyValueObservingOptionNew context:NULL];
        
        /** 目标存储区(临时). */
        NSURL *destinStore = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"Temp.sqlite"];
        
        success = [migrationManager migrateStoreFromURL:sourceStore type:NSSQLiteStoreType options:nil withMappingModel:mappingModel toDestinationURL:destinStore destinationType:NSSQLiteStoreType destinationOptions:nil error:&error];
        
        
        /** 步骤三: 成功完成迁移过程, 清理旧的存储区, 再把迁移过来的新的存储区再放回原来的位置上, 文件名起的和旧存储区一样. */
        
        if (success) {
            
            if ([self replaceStore:sourceStore withStore:destinStore]) {
                if (debug == 1) {
                    NSLog(@"SUCCESSFULLY MIGRATED %@ to the Current Model", sourceStore.path);
                    
                    [migrationManager removeObserver:self forKeyPath:@"migrationProgress"];
                }
            } else {
                
                if (debug == 1) {
                    NSLog(@"FAILED MIGRATION: %@", error);
                }
                
            }
            
        } else {
            
            if (debug == 1) {
                NSLog(@"FAILED MIGRATION: Mapping Model is null");
            }
            

        }
        
        return YES;
        
    }
    
    
    
    
    return success;
}

#pragma mark 程序清单3-7 P57
/** 显示迁移进度. */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"migrationProgress"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            float progress = [[change objectForKey:@"NSKeyValueChangeNewKey"] floatValue];
            self.migrationVC.progressView.progress = progress;
            int percentage = progress * 100;
            NSString *string = [NSString stringWithFormat:@"Migration Progress: %i%%", percentage];
            NSLog(@"%@", string);
            self.migrationVC.label.text = string;
            
        });
    }
}

/** 清理旧的存储区, 将目标存储区移动到旧的存储区.  */
- (BOOL)replaceStore:(NSURL *)old withStore:(NSURL *)new {
    
    BOOL success = NO;
    NSError *error = nil;
    if ([[NSFileManager defaultManager] removeItemAtURL:old error:&error]) {
        error = nil;
        
        if ([[NSFileManager defaultManager] moveItemAtURL:new toURL:old error:&error]) {
            success = YES;
        } else {
            if (debug == 1) {
                NSLog(@"FAILED to re-home new store %@", error);
            }
        }
        
    } else {
        
        if (debug == 1) {
            NSLog(@"FAILED to remove old store %@: Error: %@", old, error);
        }
        
    }
    return success;
}

#pragma mark - 程序清单3-8 P58

/** 把MigrationVC视图显示出来. */
- (void)performBackgroundManagedMigrationForStore:(NSURL *)storeURL {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.migrationVC = [sb instantiateViewControllerWithIdentifier:@"migration"];
    UIApplication *sa = [UIApplication sharedApplication];
    UINavigationController *nc = (UINavigationController *)sa.keyWindow.rootViewController;
    [nc presentViewController:self.migrationVC animated:NO completion:nil];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        BOOL done = [self migrateStore:storeURL];
        if (done) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = nil;
                
                _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error];
                if (!_store) {
                    NSLog(@"Failed to add a migrated store. Error: %@", error);
                    abort();
                } else {
                    NSLog(@"Successfully added a migrated store: %@", _store);
                }
                
                [self.migrationVC dismissViewControllerAnimated:NO completion:nil];
                self.migrationVC = nil;
                
            });
        }

        
    });
    
    
}



@end
