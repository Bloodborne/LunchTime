//
//  DetailedFood+Create.h
//  LunchTime
//
//  Created by BloodBorne on 15-4-24.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "DetailedFood.h"
#import "FoodEvent.h"
@interface DetailedFood (Create)

+(DetailedFood *)createFood:(NSDictionary *)food forFoodEvent:(FoodEvent *)foodEvent InManagedObjectContext:(NSManagedObjectContext *)context;

@end
