//
//  DetailedFood.h
//  LunchTime
//
//  Created by BloodBorne on 15-4-26.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodEvent;

@interface DetailedFood : NSManagedObject

@property (nonatomic, retain) NSString * itemkey;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) FoodEvent *foodEvent;

@end
