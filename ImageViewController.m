//
//  ImageViewController.m
//  LunchTime
//
//  Created by Nadesico on 15/5/11.
//  Copyright (c) 2015年 VVV. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property(nonatomic,strong)UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

-(void)setImageData:(NSData *)imageData
{
    _imageData = imageData;
    self.image =[UIImage imageWithData:_imageData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.image;
}

@end
