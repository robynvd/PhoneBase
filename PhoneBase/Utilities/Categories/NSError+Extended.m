//
//  NSError+Extended.m
//  PhoneBase
//
//  Created by Robyn Van Deventer on 22/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "NSError+Extended.h"

@implementation NSError (Extended)

+ (NSError *)errorWithMessage:(NSString *)message
{
    NSError *error = [NSError errorWithDomain:@"PB Error" code:01 userInfo:@{ NSLocalizedDescriptionKey : message } ];
    return error;
}

@end
