//
//  FoodEvent+Create.m
//  LunchTime
//
//  Created by BloodBorne on 15-4-24.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "FoodEvent+Create.h"

@implementation FoodEvent (Create)

+(FoodEvent *)createFoodEventWithDictionary:(NSDictionary *)event InManagedObjectContext:(NSManagedObjectContext *)context
{
    FoodEvent *foodEvent=[NSEntityDescription insertNewObjectForEntityForName:@"FoodEvent" inManagedObjectContext:context];
    foodEvent.lunchTime=[NSDate date];
    foodEvent.latitude=event[@"latitude"];
    foodEvent.longtitude=event[@"longtitude"];
    
    NSLog(@"create foodevent");
    
    return foodEvent;
}


@end
