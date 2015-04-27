//
//  DetailFoodTableViewController.m
//  LunchTime
//
//  Created by BloodBorne on 15-4-24.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "DetailFoodTableViewController.h"
#import "DetailedFood.h"

@interface DetailFoodTableViewController ()

@property(nonatomic)NSInteger numberOfFood;

@end

@implementation DetailFoodTableViewController

-(NSDate *)lunchTime
{
    if(!_lunchTime) _lunchTime=[[NSDate alloc]init];
    return _lunchTime;
}


//-(NSInteger)numberOfFood
//{
//    if(!_numberOfFood) _numberOfFood=1;
//    return _numberOfFood;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=[NSString stringWithFormat:@"%@",self.lunchTime];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return self.numberOfFood;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"food detail" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

//- (IBAction)addFood:(id)sender
//{
//    [DetailedFood createFoodInManagedObjectContext:self.managedObjectContext];
//    [self.tableView reloadData];
//}



@end
