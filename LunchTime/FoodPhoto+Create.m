//
//  FoodPhoto+Create.m
//  LunchTime
//
//  Created by BloodBorne on 15-4-27.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "FoodPhoto+Create.h"

@implementation FoodPhoto (Create)

+(FoodPhoto *)createPhoto:(NSDictionary *)photo InManagedObjectContext:(NSManagedObjectContext *)context
{
    FoodPhoto *newPhoto=[NSEntityDescription insertNewObjectForEntityForName:@"FoodPhoto" inManagedObjectContext:context];
    newPhoto.imageData=photo[@"imageData"];
    
    return newPhoto;
}

@end
