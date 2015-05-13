//
//  DetailedFood.h
//  LunchTime
//
//  Created by Nadesico on 15/5/13.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodEvent, FoodPhoto;

@interface DetailedFood : NSManagedObject

@property (nonatomic, retain) NSString * itemkey;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) FoodEvent *foodEvent;
@property (nonatomic, retain) FoodPhoto *foodPhoto;

@end
