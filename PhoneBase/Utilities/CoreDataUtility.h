//
//  CoreDataUtility.h
//  PhoneBase
//
//  Created by Robyn Van Deventer on 5/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Phone.h"

/**
 *  A core data utility class that handles the saving, changing and removing
 *  of objects from core data.
 */
@interface CoreDataUtility : NSObject

/**
 *  Removes all phone objects from core data.
 *
 *  @param completionHandler Returns a boolean indicating success and an error if there is one
 */
+ (void)removeAllPhonesWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

/**
 *  Creates a new phone object from a dictionary that is passed in.
 *
 *  @param dictionary        A dictionary of values to initialise the phone with
 *  @param completionHandler Returns a boolean indicating success and an error if there is one
 */
+ (void)createPhoneEntityFromDictionary:(NSDictionary *)dictionary withCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

/**
 *  Removes a specific phone from core data with the identifer that is passed in
 *
 *  @param identifier        The unique identifier of the phone to be removed
 *  @param completionHandler Returns a boolean indicating success and an error if there is one
 */
+ (void)removePhoneEntityWithIdentifier:(NSString *)identifier withCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

/**
 *  Changes the status of a phone object with the identifier that is passed in
 *
 *  @param identifier        The unique identifier of the phone to be changed
 *  @param completionHandler Returns a boolean indicating success and an error if there is one
 */
+ (void)changePhoneEntityWithIdentifier:(NSString *)identifier withCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

@end
