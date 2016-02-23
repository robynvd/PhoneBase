//
//  PBAnnotationView.h
//  PhoneBase
//
//  Created by Robyn Van Deventer on 12/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Creates a custom callout for the map view's annotations
 */
@interface PBAnnotationView : MKPinAnnotationView

/**
 *  Initialises the callout with the passed in annotation.
 *  The callout compromises of two labels and an accessory button for the
 *  purpose of pushing a detail view controller
 *
 *  @param annotation      The specific annotation for this view
 *  @param reuseIdentifier The reuse identifier
 *
 *  @return Returns self. The custom callout
 */
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic, copy) void (^onTap)();

@end
