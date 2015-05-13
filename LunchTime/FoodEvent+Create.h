//
//  FoodEvent+Create.h
//  LunchTime
//
//  Created by BloodBorne on 15-4-24.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "FoodEvent.h"

@interface FoodEvent (Create)

+(FoodEvent *)createFoodEventWithDictionary:(NSDictionary *)event InManagedObjectContext:(NSManagedObjectContext *)context;

@end
