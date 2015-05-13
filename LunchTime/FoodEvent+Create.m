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
    //get formatted system time
    NSDate *date = [NSDate date];
    foodEvent.lunchTime= [self formattedDateFromOriginDate:date];
    
    foodEvent.latitude=event[@"latitude"];
    foodEvent.longtitude=event[@"longtitude"];
    foodEvent.location = event[@"location"];
    
    NSLog(@"create foodevent");
    
    return foodEvent;
}

+(NSString *)formattedDateFromOriginDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

@end
