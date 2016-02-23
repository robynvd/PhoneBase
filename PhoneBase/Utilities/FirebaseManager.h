//
//  FirebaseManager.h
//  PhoneBase
//
//  Created by Robyn Van Deventer on 23/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirebaseManager : NSObject

/**
 *  Creates a shared manager for the Firebase manager
 *
 *  @return The shared manager
 */
+ (instancetype)sharedManager;

/**
 *  Syncs core data with the objects stored in the Firebase database.
 *  This will set up all the types of observers for Firebase to listen for changes.
 *  After changes are detected, these changes are passed on to core data.
 *
 *  @param completionHandler Returns a boolean indicating success and an error if there is one
 */
- (void)initialiseLostPhonesWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

/**
 *  Adds a phone to the Firebase database.
 *  Gets the current address and location from the location manager.
 *  Sets the status to lost and generates a unique identifier for the phone.
 *
 *  @param completionHandler Returns a boolean indicating success and an error if there is one
 */
- (void)addLostPhoneToDatabaseWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

/**
 *  Updates the status of a specific phone in the database.
 *  Reverses the current status of the phone.
 *
 *  @param status            The current status of the phone
 *  @param identifier        The unique identifier of the phone to be updated
 *  @param completionHandler Returns a boolean indicating success and an error if there is one
 */
- (void)updateStatus:(BOOL)status ofPhone:(NSString *)identifier withCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

@end
