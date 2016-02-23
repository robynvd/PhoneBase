//
//  PBTableHeaderView.m
//  PhoneBase
//
//  Created by Robyn Van Deventer on 19/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "PBTableHeaderView.h"

static CGFloat const TableHeaderViewButtonSize = 18;

@implementation PBTableHeaderView

/**
 *  The custom header view
 *
 *  @return Returns self
 */
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        
        UILabel *headerTitleLabel = [[UILabel alloc] init];
        headerTitleLabel.text = @"IPHONES";
        headerTitleLabel.textColor = [UIColor whiteColor];
        headerTitleLabel.font = [UIFont mapViewTableHeaderTitleFont];
        [self addSubview:headerTitleLabel];
        
        self.headerButton = [[UIButton alloc] init];
        [self.headerButton setImage:[[UIImage imageNamed:@"downArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                      forState:UIControlStateNormal];
        self.headerButton.tintColor = [UIColor whiteColor];
        [self addSubview:self.headerButton];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  NSLayoutConstraintMakeEqual(headerTitleLabel, ALCenterX, self),
                                                  NSLayoutConstraintMakeEqual(headerTitleLabel, ALCenterY, self),
                                                  NSLayoutConstraintMakeAll(headerTitleLabel, ALWidth, ALEqual, nil, ALWidth, 1.0, 80, UILayoutPriorityRequired),
                                                  NSLayoutConstraintMakeAll(headerTitleLabel, ALHeight, ALEqual, nil, ALHeight, 1.0, 18, UILayoutPriorityRequired),
                                                  
                                                  NSLayoutConstraintMakeInset(self.headerButton, ALRight, -6),
                                                  NSLayoutConstraintMakeEqual(self.headerButton, ALCenterY, self),
                                                  NSLayoutConstraintMakeAll(self.headerButton, ALHeight, ALEqual, nil, ALHeight, 1.0, TableHeaderViewButtonSize, UILayoutPriorityRequired),
                                                  NSLayoutConstraintMakeAll(self.headerButton, ALWidth, ALEqual, nil, ALWidth, 1.0, TableHeaderViewButtonSize, UILayoutPriorityRequired),
                                                  ]];

    }
    return self;
}

@end
