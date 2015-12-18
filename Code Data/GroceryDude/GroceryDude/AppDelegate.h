//
//  AppDelegate.h
//  GroceryDude
//
//  Created by dllo on 15/12/1.
//  Copyright © 2015年 rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;

@end

