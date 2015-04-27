//
//  DetailedFood+Create.m
//  LunchTime
//
//  Created by BloodBorne on 15-4-24.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "DetailedFood+Create.h"

@implementation DetailedFood (Create)

+(DetailedFood *)createFood:(NSDictionary *)food forFoodEvent:(FoodEvent *)foodEvent InManagedObjectContext:(NSManagedObjectContext *)context
{
    DetailedFood *newFood=[NSEntityDescription insertNewObjectForEntityForName:@"DetailedFood" inManagedObjectContext:context];
    newFood.name=food[@"name"];
    newFood.price=food[@"price"];
    newFood.itemkey=food[@"itemkey"];
    newFood.foodEvent=foodEvent;
    
    NSLog(@"create food");
    
    return newFood;
}

@end
