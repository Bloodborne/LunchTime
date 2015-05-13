//
//  PhotosByFoodEventMapViewController.m
//  LunchTime
//
//  Created by Nadesico on 15/5/11.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "PhotosByFoodEventMapViewController.h"
#import "MapKit/MapKit.h"
#import "FoodEvent+Annotation.h"
#import "FoodDatabaseAvailability.h"
#import "DetailedFood.h"
#import "FoodPhoto.h"
#import "UIImage+Scale.h"
#import "DetailFoodTableViewController.h"

@interface PhotosByFoodEventMapViewController()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSArray *foodEvent;

@end

@implementation PhotosByFoodEventMapViewController

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
}

-(void)awakeFromNib
{
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
    
    NSError *error;
    self.foodEvent = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!self.foodEvent || error) {
        NSLog(@"%@",error);
    }
    else NSLog(@"oh...");
    [self updateMapViewAnnotations];
}

-(void)updateMapViewAnnotations
{
    
    if(self.managedObjectContext) NSLog(@"YES!");
    else NSLog(@"NO!!!");
    //NSLog(@"foodEvent : %@ %@",[self.foodEvent[0] longtitude],[self.foodEvent[0] latitude]);
    
    [self.mapView addAnnotations:self.foodEvent];
    [self.mapView showAnnotations:self.foodEvent animated:YES];
    
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseID = @"PhotosByFoodEventMapViewController";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    if(!view)
    {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                            reuseIdentifier:reuseID];
        
        view.canShowCallout = YES;
        
        //show the thumnail
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        view.leftCalloutAccessoryView = imageView;
        UIButton *disclosureButton = [[UIButton alloc] init];
        [disclosureButton setBackgroundImage:[UIImage imageNamed:@"disclosure"] forState:UIControlStateNormal];
        [disclosureButton sizeToFit];
        view.rightCalloutAccessoryView = disclosureButton;
    }
    view.annotation = annotation;
    return view;
    
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self updateLeftCalloutAcessaryViewController:view];
}

-(void)updateLeftCalloutAcessaryViewController:(MKAnnotationView *)annotationView
{
    UIImageView *imageView  = nil;
    if([annotationView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]])
        imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
    if(imageView)
    {
        FoodEvent *foodEvent = nil;
        DetailedFood *food = nil;
        if([annotationView.annotation isKindOfClass:[FoodEvent class]])
            foodEvent = (FoodEvent *)annotationView.annotation;
        if(foodEvent.containFoods.foodPhoto)
        {
            food = foodEvent.containFoods;
            UIImage *image = [UIImage imageWithData:food.foodPhoto.imageData];
            imageView.image = [image imageByScalingToSize:CGSizeMake(46, 46)];
        }
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"show detail" sender:view];
}

#pragma mark - Navigation

-(void)prepareController:(id)vc forSegue:(NSString *)segueIdentifier toShowAnnotation:(id<MKAnnotation>)annotation
{
    FoodEvent *foodEvent = nil;
    if([annotation isKindOfClass:[FoodEvent class]])
        foodEvent = (FoodEvent *)annotation;
    if(foodEvent) {
        if( !segueIdentifier.length || [segueIdentifier isEqualToString:@"show detail"]) {
            if([vc isKindOfClass:[DetailFoodTableViewController class]]){
                DetailFoodTableViewController *dftvc = (DetailFoodTableViewController *)vc;
                dftvc.foodEvent = foodEvent;
            }
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.destinationViewController isKindOfClass:[DetailFoodTableViewController class]])
//    {
//        DetailFoodTableViewController *dftvc = (DetailFoodTableViewController *)segue.destinationViewController;
//        //dftvc.foodEvent =
//    }
//    else if ([sender isKindOfClass:[MKAnnotationView class]])
    {
        [self prepareController:segue.destinationViewController
                       forSegue:segue.identifier
               toShowAnnotation:((MKAnnotationView *)sender).annotation];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [self updateMapViewAnnotations];
}

@end
