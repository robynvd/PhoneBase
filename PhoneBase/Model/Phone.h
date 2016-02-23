//
//  Phone.h
//  PhoneBase
//
//  Created by Robyn Van Deventer on 4/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Phone objects are of type MKAnnotation.
 */
@interface Phone : NSManagedObject <MKAnnotation>

/**
 *  Sets the attributes of the phone object from the dictionary that is passed in
 *
 *  @param dictionary The dictionary containing the phone attributes
 */
- (void)fillPropertiesFromDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

#import "Phone+CoreDataProperties.h"
