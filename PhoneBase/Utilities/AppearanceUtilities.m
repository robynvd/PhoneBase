//
//  AppearanceUtilities.m
//  PhoneBase
//
//  Created by Robyn Van Deventer on 23/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "AppearanceUtilities.h"

# pragma mark - Sizing

@implementation AppearanceUtilities

//Detail view controller constants
+ (CGFloat)detailViewVerticalSpacing
{
    if ([UIScreen mainScreen].bounds.size.height > 600)
    {
        return 75;
    }
    else if ([UIScreen mainScreen].bounds.size.height > 500)
    {
        return 75 * 0.6;
    }
    else
    {
        return 75 * 0.15;
    }
}

+ (CGFloat)detailViewAddressSpacing
{
    if ([UIScreen mainScreen].bounds.size.height > 600)
    {
        return 30;
    }
    else if ([UIScreen mainScreen].bounds.size.height > 500)
    {
        return 30 * 0.6;
    }
    else
    {
        return 30 * 0.15;
    }
}

//Lost phones view controller constants
+ (CGFloat)mapViewTableHeight
{
    if ([UIScreen mainScreen].bounds.size.height > 600)
    {
        return 250;
    }
    else if ([UIScreen mainScreen].bounds.size.height > 500)
    {
        return 250 * 0.85;
    }
    else
    {
        return 250 * 0.71;
    }
}

@end

# pragma mark - Colors

@implementation UIColor (AppearanceUtilities)

//Callout view colors
+ (UIColor*)calloutViewBackgroundColor                                { return [UIColor colorWithRed:0.35 green:0.34 blue:0.33 alpha:1]; }

@end

#pragma mark - Fonts

@implementation UIFont (AppearanceUtilities)

//Detail view controller fonts
+ (UIFont *)detailViewUniqueIDFont                                    { return [UIFont systemFontOfSize:24]; }
+ (UIFont *)detailViewLabelFont                                       { return [UIFont systemFontOfSize:16]; }

//Lost phones view controller fonts
+ (UIFont *)mapViewTableHeaderTitleFont                               { return [UIFont systemFontOfSize:12]; }

//Callout view fonts
+ (UIFont *)calloutViewTitleFont                                      { return [UIFont systemFontOfSize:16]; }
+ (UIFont *)calloutViewSubtitleFont                                   { return [UIFont systemFontOfSize:11]; }

@end