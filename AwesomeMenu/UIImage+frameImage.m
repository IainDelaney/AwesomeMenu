//
//  UIImage+frameImage.m
//  DragTest
//
//  Created by Iain Delaney on 2013-04-24.
//  Copyright (c) 2013 Thumbprint. All rights reserved.
//

#import "UIImage+frameImage.h"

@implementation UIImage (frameImage)
+ (UIImage *)imageWithSize:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    [[UIColor clearColor] setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
