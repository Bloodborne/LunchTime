//
//  FoodPhoto+Annotation.m
//  LunchTime
//
//  Created by Nadesico on 15/5/11.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "FoodEvent+Annotation.h"

@implementation FoodEvent (Annotation)

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longtitude doubleValue];
    
    return coordinate;
}

-(NSString *)title
{
    return self.location;
}

-(NSString *)subtitle
{
    return self.lunchTime;
}

@end
