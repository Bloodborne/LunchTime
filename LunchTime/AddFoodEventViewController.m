//
//  AddFoodEventViewController.m
//  LunchTime
//
//  Created by BloodBorne on 15-4-25.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

//********************************************************************
//it should be modal segue to a new view when adding a new detail food
//********************************************************************

#import "AddFoodEventViewController.h"
#import "DetailedFood.h"
#import "DetailedFood+Create.h"
#import "FoodEvent+Create.h"
#import "CoreLocation/CoreLocation.h"
#import <MobileCoreServices/MobileCoreServices.h>   // kUTTypeImage

@interface AddFoodEventViewController ()<UITextFieldDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLLocation *location;
@property(nonatomic)NSInteger locationErrorCode;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation AddFoodEventViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.delegate=self;
    self.priceTextField.delegate=self;
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted)
        [self.locationManager startUpdatingLocation];
    else
    {
        [self alert:@"Sorry,cannot locate"];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

//为什么键盘不能消失？？？
//update:没有设置delegate为self...
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Target/Action

- (IBAction)done
{
    NSString *name=self.nameTextField.text;
    NSNumber *price=@([self.priceTextField.text intValue]);
    if(name.length>0 && price)
    {
        NSDictionary *event=@{@"latitude":@(self.location.coordinate.latitude),@"longtitude":@(self.location.coordinate.longitude)};
        FoodEvent *foodEvent=[FoodEvent createFoodEventWithDictionary:event InManagedObjectContext:self.managedObjectContext];
        self.foodEvent=foodEvent;
        
        NSUUID *uuid=[[NSUUID alloc]init];
        NSDictionary *food=@{@"name":name,@"price":price,@"uuid":[uuid UUIDString]};
        
        [DetailedFood createFood:food forFoodEvent:self.foodEvent InManagedObjectContext:self.managedObjectContext];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addPhoto:(id)sender
{
    if([self canAddPhoto])
    {
        UIImagePickerController *uiipc=[[UIImagePickerController alloc]init];
        uiipc.delegate=self;
        uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
        uiipc.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:uiipc animated:YES completion:nil];
    }
    else
        [self alert:@"Sorry,this device cannot add a photo."];
        
}

-(BOOL)canAddPhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSArray *availableMediaTypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([availableMediaTypes containsObject:(NSString *)kUTTypeImage])
            return YES;
    }
    return NO;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=info[UIImagePickerControllerEditedImage];
    if(!image) image=info[UIImagePickerControllerOriginalImage];
    self.imageView.image=image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Location

-(CLLocationManager *)locationManager
{
    if(!_locationManager)
    {
        _locationManager=[[CLLocationManager alloc]init];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    }
    return _locationManager;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location=[locations lastObject];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.locationErrorCode=error.code;
    NSLog(@"%@",error);
    if (!self.location)
    {
        switch (self.locationErrorCode)
        {
            case kCLErrorLocationUnknown:
                [self alert:@"Couldn't figure out where this photo was taken (yet)."]; break;
            case kCLErrorDenied:
                [self alert:@"Location Services disabled under Privacy in Settings application."]; break;
            case kCLErrorNetwork:
                [self alert:@"Can't figure out where this photo is being taken.  Verify your connection to the network."]; break;
            default:
                [self alert:@"Cant figure out where this photo is being taken, sorry."]; break;
        }
    }

}

#pragma mark - Alerts
-(void)alert:(NSString *)message
{
    [[[UIAlertView alloc]initWithTitle:@"Warning!"
                               message:message
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK",nil] show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self cancel];
}

@end
