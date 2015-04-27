//
//  DetailFoodTableViewController.h
//  LunchTime
//
//  Created by BloodBorne on 15-4-24.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface DetailFoodTableViewController : CoreDataTableViewController

@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong)NSDate *lunchTime;

@end
