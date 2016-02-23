//
//  LocationManager.h
//  PhoneBase
//
//  Created by Robyn Van Deventer on 5/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

/**
 *  Creates a shared manager for the location manager
 *
 *  @return The shared manager
 */
+ (instancetype)sharedManager;

/**
 *  Uses the location manager to return the user's current location
 *
 *  @return The user's current location
 */
- (CLLocation *)currentLocation;

/**
 *  Uses reverse geo location to get an address from the user's current location.
 *
 *  @param completionHandler Returns the address, latitude, longitude and an error if there is one
 */
- (void)getAddressFromCurrentLocationWithCompletionHandler:(void (^)(NSString *address, CGFloat latitude, CGFloat longitude, NSError *error))completionHandler;

@end
