//
//  FoodPhoto.h
//  LunchTime
//
//  Created by Nadesico on 15/5/13.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DetailedFood;

@interface FoodPhoto : NSManagedObject

@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) DetailedFood *detailFood;

@end
