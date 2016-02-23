//
//  LocationManager.m
//  PhoneBase
//
//  Created by Robyn Van Deventer on 5/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationManager

+ (instancetype)sharedManager
{
    static LocationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[LocationManager alloc] init];
    });
    
    return _sharedManager;
}

/**
 *  Initialises the location manager and starts updating location
 *
 *  @return The location manager
 */
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.distanceFilter = 50;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (CLLocation *)currentLocation
{
    return self.locationManager.location;
}

- (void)getAddressFromCurrentLocationWithCompletionHandler:(void (^)(NSString *address, CGFloat latitude, CGFloat longitude, NSError *error))completionHandler
{
    __block NSString *address;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder  reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
     {
         if (error)
         {
             completionHandler(nil, 0, 0, [NSError errorWithMessage:@"Could not get an address for your location"]);
         }
         else
         {
             address = [NSString stringWithFormat:@"%@ %@, %@ %@", placemarks[0].subThoroughfare, placemarks[0].thoroughfare, placemarks[0].locality, placemarks[0].postalCode];
             completionHandler(address, self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, nil);
         }
     }];
}

@end
