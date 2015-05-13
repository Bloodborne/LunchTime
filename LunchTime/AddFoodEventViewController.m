//
//  AddFoodEventViewController.m
//  LunchTime
//
//  Created by BloodBorne on 15-4-25.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

//********************************************************************
//it should be modal segue to a new view when adding a new detail food
//还没处理没有照片所造成程序crash的原因
//update:5.13 4:50 定位功能将CLLocation换为MapKit，因为MapKit用的是火星坐标，能匹配天朝的火星地图
//********************************************************************

#import "AddFoodEventViewController.h"
#import "DetailedFood+Create.h"
#import "FoodEvent+Create.h"
#import "FoodPhoto+Create.h"
#import "CoreLocation/CoreLocation.h"
#import <MobileCoreServices/MobileCoreServices.h>   // kUTTypeImage
#import "MapKit/MapKit.h"

@interface AddFoodEventViewController ()<UITextFieldDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property(nonatomic)NSInteger locationErrorCode;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) UIImage *image;
@property(nonatomic,strong) FoodPhoto *photo;
@property(nonatomic,strong) MKMapView *mapView;
@property(nonatomic,strong) MKUserLocation *MKLocation;
@property (nonatomic,strong) NSString *address;
@end

@implementation AddFoodEventViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.delegate=self;
    self.priceTextField.delegate=self;
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted){
        _mapView = [[MKMapView alloc] init];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
    }
    else{
        [self alert:@"Sorry,cannot locate"];
    }
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
        if(self.imageView.image)
            [self savePhoto];
        
        if(!self.address){
            self.address = @"Unknown";
        }
        
        NSDictionary *event=@{@"latitude":@(self.MKLocation.location.coordinate.latitude),
                              @"longtitude":@(self.MKLocation.location.coordinate.longitude),
                              @"location":self.address};
        NSLog(@"%@",event);
        FoodEvent *foodEvent=[FoodEvent createFoodEventWithDictionary:event InManagedObjectContext:self.managedObjectContext];
        self.foodEvent=foodEvent;
        
        NSUUID *uuid=[[NSUUID alloc]init];
        NSDictionary *food=@{@"name":name,@"price":price,@"itemkey":[uuid UUIDString],@"foodPhoto":self.photo};
        
        [DetailedFood createFood:food forFoodEvent:self.foodEvent InManagedObjectContext:self.managedObjectContext];
        [self.managedObjectContext save:NULL];
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
    self.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)savePhoto
{
    //NSURL *url=[self uniqueDocumentURL];
    NSData *data = UIImageJPEGRepresentation(self.image, 0.5);
    NSDictionary *photo = @{@"imageData":data};
    self.photo = [FoodPhoto createPhoto:photo
                 InManagedObjectContext:self.managedObjectContext];
}

-(NSURL *)uniqueDocumentURL
{
    NSArray *documentDirectories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSString *unique = [NSString stringWithFormat:@"%.0f",floor([NSDate timeIntervalSinceReferenceDate])];
    return [[documentDirectories firstObject] URLByAppendingPathComponent:unique];
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.MKLocation = userLocation;
    
    [self getAddressFromLocation:self.MKLocation.location completionBlock:^(NSString * address) {
        if(address) {
            self.address = address;
            NSLog(@"address : %@",address);
        }
    }];
}

-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    self.locationErrorCode=error.code;
    NSLog(@"%@",error);
    if (!self.MKLocation)
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

-(void)getAddressFromLocation:(CLLocation *)location
              completionBlock:(void(^)(NSString *))completionBlock
{
    __block CLPlacemark* placemark;
    __block NSString *address = nil;
    
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             NSLog(@"placemarks : %@",placemarks);
             NSLog(@"lastObject : %@",placemark);
             address = [NSString stringWithFormat:@"%@", placemark.name];
             completionBlock(address);
         }
     }];
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
