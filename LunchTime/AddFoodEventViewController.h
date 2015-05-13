//
//  AddFoodEventViewController.h
//  LunchTime
//
//  Created by BloodBorne on 15-4-25.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodEvent.h"

@interface AddFoodEventViewController : UIViewController

@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong)FoodEvent *foodEvent;

@end
