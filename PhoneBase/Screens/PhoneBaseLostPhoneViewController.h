//
//  PhoneBaseLostPhoneViewController.h
//  PhoneBase
//
//  Created by Robyn Van Deventer on 4/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone.h"

/**
 *  The detail view controller of PhoneBase. Displays further information
 *  about a phone instance. Allows the user to toggle the status of the phone
 *  from lost to found and vice versa.
 */
@interface PhoneBaseLostPhoneViewController : UIViewController

/**
 *  Initialises the view controller with an instance of a phone
 *  and the background image from the previous view
 *
 *  @param phone The phone object being displayed
 *  @param image The background of the view
 *
 *  @return Returns self. The view controller
 */
- (instancetype)initWithPhone:(Phone *)phone andImage:(UIImage *)image;

@end
