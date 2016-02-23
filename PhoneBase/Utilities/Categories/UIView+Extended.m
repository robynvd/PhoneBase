//
//  UIView+Extended.m
//  PhoneBase
//
//  Created by Robyn Van Deventer on 11/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "UIView+Extended.h"

/**
 *  Converts a snapshot of a current view into an image
 */
@implementation UIView (Extended)

- (UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
