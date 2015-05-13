//
//  FoodEventTableViewController.m
//  LunchTime
//
//  Created by BloodBorne on 15-4-24.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "FoodEventTableViewController.h"
#import "DetailFoodTableViewController.h"
#import "FoodDatabaseAvailability.h"
#import "FoodEvent.h"
#import "DetailedFood.h"
#import "AddFoodEventViewController.h"
#import "PhotosByFoodEventMapViewController.h"


@interface FoodEventTableViewController ()

@property(nonatomic,strong)NSMutableArray *foodEvent;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addFoodEventButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

@implementation FoodEventTableViewController

- (IBAction)edit:(id)sender
{
    [self setEditing:!self.tableView.editing animated:YES];
    if(self.tableView.editing)
    {
        [self.addFoodEventButton setEnabled:NO];
        self.editButton.title=@"Done";
    }
    else
    {
        [self.addFoodEventButton setEnabled:YES];
        self.editButton.title=@"Edit";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserverForName:FoodDatabaseAvailabilityNotification
                                                     object:nil
                                                      queue:nil
                                                 usingBlock:^(NSNotification *note) {
        self.managedObjectContext=note.userInfo[FoodDatabaseAvailabilityContext];
    }];

}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext=managedObjectContext;
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"FoodEvent"];
    request.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"lunchTime" ascending:NO]];
    
    self.fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                     managedObjectContext:self.managedObjectContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"food event" forIndexPath:indexPath];
    FoodEvent *foodEvent=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=[foodEvent.containFoods.price stringValue];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",foodEvent.latitude,foodEvent.longtitude];
    // Configure the cell...
    NSLog(@"%@ %@",foodEvent.latitude,foodEvent.longtitude);
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        FoodEvent *foodEvent=[self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:foodEvent];
        
        NSError *error;
        [self.managedObjectContext save:&error];
        if(error)
            NSLog(@"Error:%@",error);
    }
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DetailFoodTableViewController *dftvc=[[DetailFoodTableViewController alloc]init];
//    FoodEvent *foodEvent = self.fetchedResultsController.fetchedObjects[indexPath.row];
//    dftvc.foodEvent = foodEvent;
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];
    
    if([segue.destinationViewController isKindOfClass:[DetailFoodTableViewController class]])
    {
        DetailFoodTableViewController *dftvc=(DetailFoodTableViewController *)segue.destinationViewController;
        FoodEvent *foodEvent = self.fetchedResultsController.fetchedObjects[indexPath.row];
        dftvc.foodEvent = foodEvent;
    }
    
    else if([segue.destinationViewController isKindOfClass:[AddFoodEventViewController class]])
    {
        AddFoodEventViewController *afevc=(AddFoodEventViewController *)segue.destinationViewController;
        afevc.managedObjectContext=self.managedObjectContext;
        
    }
}

-(void)prepareForDetailFoodTableViewController
{
    
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(contextChanged:)
//                                                 name:NSManagedObjectContextDidSaveNotification
//                                               object:self.managedObjectContext];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:NSManagedObjectContextDidSaveNotification
//                                                  object:self.managedObjectContext];
//    [super viewWillDisappear:animated];
//}
//
//- (void)contextChanged:(NSNotification *)notification
//{
//    [self performFetch];
//}

@end
