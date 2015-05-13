//
//  DetailFoodTableViewController.m
//  LunchTime
//
//  Created by BloodBorne on 15-4-24.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "DetailFoodTableViewController.h"
#import "DetailedFood.h"
#import "FoodPhoto.h"
#import "ImageViewController.h"

@interface DetailFoodTableViewController ()

@end

@implementation DetailFoodTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title= self.foodEvent.lunchTime;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"food detail" forIndexPath:indexPath];
    DetailedFood *food = self.foodEvent.containFoods;
    
    UIImage *image = [UIImage imageWithData:food.foodPhoto.imageData];
    
    cell.textLabel.text = food.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",food.price];
    cell.imageView.image = image;
    
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"show photo"])
    {
        ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
        ivc.imageData = self.foodEvent.containFoods.foodPhoto.imageData;
    }
}



@end
