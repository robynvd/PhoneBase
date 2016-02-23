//
//  Phone.m
//  PhoneBase
//
//  Created by Robyn Van Deventer on 4/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "Phone.h"

@implementation Phone

- (void)fillPropertiesFromDictionary:(NSDictionary *)dictionary
{
    self.uniqueID = dictionary[@"uniqueID"];
    self.address = dictionary[@"address"];
    self.lostStatus = [NSNumber numberWithBool:[dictionary[@"lostStatus"] boolValue]];
    self.latitude = @([dictionary[@"latitude"] doubleValue]);
    self.longitude = @([dictionary[@"longitude"] doubleValue]);
}

/**
 *  Creates a coordinate location of the phone annotation
 *
 *  @return The coordinates of the annotation
 */
- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

/**
 *  The title of the phone annotation
 *
 *  @return The annotation title
 */
- (NSString *)title
{
    return self.uniqueID;
}

/**
 *  The subtitle of the phone annotation
 *
 *  @return The annotation subtitle
 */
- (NSString *)subtitle
{
    return self.address;
}

@end
