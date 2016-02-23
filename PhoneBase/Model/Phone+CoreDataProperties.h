//
//  Phone+CoreDataProperties.h
//  PhoneBase
//
//  Created by Robyn Van Deventer on 18/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Phone.h"

NS_ASSUME_NONNULL_BEGIN

@interface Phone (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSNumber *lostStatus;
@property (nullable, nonatomic, retain) NSString *uniqueID;

@end

NS_ASSUME_NONNULL_END
