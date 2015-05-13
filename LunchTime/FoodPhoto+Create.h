//
//  FoodPhoto+Create.h
//  LunchTime
//
//  Created by BloodBorne on 15-4-27.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "FoodPhoto.h"

@interface FoodPhoto (Create)

+(FoodPhoto *)createPhoto:(NSDictionary *)photo InManagedObjectContext:(NSManagedObjectContext *)context;

@end
