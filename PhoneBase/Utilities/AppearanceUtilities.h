//
//  AppearanceUtilities.h
//  PhoneBase
//
//  Created by Robyn Van Deventer on 23/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Returns constraint constants that are based on screen size
 */
@interface AppearanceUtilities : NSObject

//Detail view controller constants
+ (CGFloat)detailViewVerticalSpacing;
+ (CGFloat)detailViewAddressSpacing;

//Lost phones view controller constants
+ (CGFloat)mapViewTableHeight;

@end

/**
 *  Returns custom colors
 */
@interface UIColor (AppearanceUtilities)

//Callout view colors
+ (UIColor *)calloutViewBackgroundColor;

@end

/**
 *  Returns custom fonts
 */
@interface UIFont (AppearanceUtilities)

//Detail view controller fonts
+ (UIFont *)detailViewUniqueIDFont;
+ (UIFont *)detailViewLabelFont;

//Lost phones view controller fonts
+ (UIFont *)mapViewTableHeaderTitleFont;

//Callout view fonts
+ (UIFont *)calloutViewTitleFont;
+ (UIFont *)calloutViewSubtitleFont;

@end