//
//  PBAnnotationView.m
//  PhoneBase
//
//  Created by Robyn Van Deventer on 12/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "PBAnnotationView.h"
#import "PhoneBaseLostPhoneViewController.h"

static CGFloat const LabelHeight = 20;
static CGFloat const ButtonSize = 24;
static CGFloat const TopBottomInset = 6;
static CGFloat const SideInset = 10;

@implementation PBAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.canShowCallout = NO;
        self.pinTintColor = [UIColor redColor];
        
        self.calloutView = [[UIView alloc] init];
        self.calloutView.layer.cornerRadius = 5;
        self.calloutView.backgroundColor = [UIColor calloutViewBackgroundColor];
        self.calloutView.alpha = 0;
        [self addSubview:self.calloutView];
        
        UILabel *identiferLabel = [[UILabel alloc] init];
        identiferLabel.font = [UIFont calloutViewTitleFont];
        identiferLabel.textColor = [UIColor whiteColor];
        identiferLabel.text = annotation.title;
        [self.calloutView addSubview:identiferLabel];
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.font = [UIFont calloutViewSubtitleFont];
        addressLabel.textColor = [UIColor whiteColor];
        addressLabel.text = annotation.subtitle;
        [self.calloutView addSubview:addressLabel];
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonImage = [UIImage imageNamed:@"chevron"];
        UIImageView *detailButtonView = [[UIImageView alloc] initWithImage:[buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [detailButton setTintColor:[UIColor whiteColor]];
        [detailButton setImage:detailButtonView.image
                           forState:UIControlStateNormal];
        [detailButton addTarget:self action:@selector(detailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.calloutView addSubview:detailButton];
        
        [NSLayoutConstraint activateConstraints:@[
                                                    NSLayoutConstraintMakeAll(identiferLabel, ALHeight, ALEqual, nil, ALHeight, 1.0, LabelHeight, UILayoutPriorityRequired),
                                                    NSLayoutConstraintMakeAll(identiferLabel, ALTop, ALEqual, self.calloutView, ALTop, 1.0, TopBottomInset, UILayoutPriorityRequired),
                                                    NSLayoutConstraintMakeAll(identiferLabel, ALLeft, ALEqual, self.calloutView, ALLeft, 1.0, SideInset, UILayoutPriorityRequired),
                                                    NSLayoutConstraintMakeAll(identiferLabel, ALRight, ALEqual, detailButton, ALLeft, 1.0, 0, UILayoutPriorityRequired),

                                                    NSLayoutConstraintMakeAll(addressLabel, ALHeight, ALEqual, nil, ALHeight, 1.0, LabelHeight, UILayoutPriorityRequired),
                                                    NSLayoutConstraintMakeAll(addressLabel, ALBottom, ALEqual, self.calloutView, ALBottom, 1.0, -TopBottomInset, UILayoutPriorityRequired),
                                                    NSLayoutConstraintMakeAll(addressLabel, ALLeft, ALEqual, self.calloutView, ALLeft, 1.0, SideInset, UILayoutPriorityRequired),
                                                    NSLayoutConstraintMakeEqual(addressLabel, ALRight, identiferLabel),

                                                    NSLayoutConstraintMakeAll(detailButton, ALWidth, ALEqual, nil, ALWidth, 1.0, ButtonSize, UILayoutPriorityRequired),
                                                    NSLayoutConstraintMakeAll(detailButton, ALHeight, ALEqual, nil, ALHeight, 1.0, ButtonSize, UILayoutPriorityRequired),
                                                    NSLayoutConstraintMakeEqual(detailButton, ALCenterY, self.calloutView),
                                                    NSLayoutConstraintMakeAll(detailButton, ALRight, ALEqual, self.calloutView, ALRight, 1.0, -SideInset, UILayoutPriorityRequired),

                                                    NSLayoutConstraintMakeAll(self.calloutView, ALHeight, ALEqual, nil, ALHeight, 1.0, 50, UILayoutPriorityRequired),
                                                    NSLayoutConstraintMakeAll(self.calloutView, ALCenterX, ALEqual, self, ALCenterX, 1.0, 0, UILayoutPriorityRequired),
                                                    NSLayoutConstraintMakeAll(self.calloutView, ALCenterY, ALEqual, self, ALCenterY, 1.0, -45, UILayoutPriorityRequired),
                                                  ]];
        
    }
    return self;    
}

/**
 *  Executes the block within the onTap property on button tap
 */
- (void)detailButtonTapped
{
    if (self.onTap)
    {
        self.onTap();
    }
}

/**
 *  The following two methods are overriden to allow interaction
 *  with the custom callout
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

@end
