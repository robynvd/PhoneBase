//
//  PhoneBaseMapViewController.h
//  PhoneBase
//
//  Created by Robyn Van Deventer on 4/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  The main view of the application.
 *  A map view and table view display all of the lost phones added
 *  to the database by users.
 *  Clicking on the pin of a lost phone opens a callout that can push
 *  a detail view controller for that phone.
 *  Users can add a new lost phone to the database at their current location
 *  Users can also track their current location/heading
 */
@interface PhoneBaseMapViewController : UIViewController

@end
