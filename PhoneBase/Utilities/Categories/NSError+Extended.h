//
//  NSError+Extended.h
//  PhoneBase
//
//  Created by Robyn Van Deventer on 22/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  An NSError category for the creation of custom errors
 */
@interface NSError (Extended)

/**
 *  Creates a custom error with a specific message
 *
 *  @param message The error message that will be shown to the user
 *
 *  @return Returns the custom error
 */
+ (NSError *)errorWithMessage:(NSString *)message;

@end
