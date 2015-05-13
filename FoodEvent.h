//
//  FoodEvent.h
//  LunchTime
//
//  Created by Nadesico on 15/5/13.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DetailedFood;

@interface FoodEvent : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * longtitude;
@property (nonatomic, retain) NSString * lunchTime;
@property (nonatomic, retain) NSNumber * totalCost;
@property (nonatomic, retain) DetailedFood *containFoods;

@end
