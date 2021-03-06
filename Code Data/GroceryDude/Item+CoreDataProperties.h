//
//  Item+CoreDataProperties.h
//  GroceryDude
//
//  Created by Rain on 15/12/16.
//  Copyright © 2015年 rain. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *collected;
@property (nullable, nonatomic, retain) NSNumber *list;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSData *photoData;
@property (nullable, nonatomic, retain) NSNumber *quantiy;


@end

NS_ASSUME_NONNULL_END
