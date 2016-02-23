//
//  CoreDataUtility.m
//  PhoneBase
//
//  Created by Robyn Van Deventer on 5/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "CoreDataUtility.h"
#import "Phone.h"

@implementation CoreDataUtility

+ (void)removeAllPhonesWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext)
    {
        [Phone MR_truncateAllInContext:localContext];
    }
    completion:^(BOOL contextDidSave, NSError * _Nullable error)
    {
        if (error)
        {
            completionHandler(NO, [NSError errorWithMessage:@"Could not remove phones from the local database"]);
        }
        else
        {
            completionHandler(YES, nil);
        }
    }];
}

+ (void)createPhoneEntityFromDictionary:(NSDictionary *)dictionary withCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler
{
    Phone *phone = [Phone MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"uniqueID == %@", dictionary[@"uniqueID"]]];

    if (!phone)
    {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext)
         {
             Phone *phoneInContext = [Phone MR_createEntityInContext:localContext];
             [phoneInContext fillPropertiesFromDictionary:dictionary];
         }
        completion:^(BOOL contextDidSave, NSError * _Nullable error)
        {
            if (error)
            {
                completionHandler(NO, [NSError errorWithMessage:@"Could not create phone"]);
            }
            else if (!contextDidSave)
            {
                completionHandler(NO, nil);
            }
            else
                completionHandler(YES, nil);
        }];
    }
    else
    {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext)
        {
            Phone *phoneInContext = [phone MR_inContext:localContext];
            phoneInContext.lostStatus = dictionary[@"lostStatus"];
        }
        completion:^(BOOL contextDidSave, NSError * _Nullable error)
        {
            if (error)
            {
                completionHandler(NO, [NSError errorWithMessage:@"Could not sync a phone wit the database"]);
            }
            else if (!contextDidSave)
            {
                completionHandler(NO, nil);
            }
            else
            {
                completionHandler(YES, nil);
            }
        }];
    }
}

+ (void)removePhoneEntityWithIdentifier:(NSString *)identifier withCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler
{
    Phone *phone = [Phone MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"uniqueID == %@", identifier]];
    
    if (phone)
    {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext)
        {
            [phone MR_deleteEntityInContext:localContext];
        }
        completion:^(BOOL contextDidSave, NSError * _Nullable error)
        {
            if (error)
            {
                completionHandler(NO, [NSError errorWithMessage:@"Could not delete phone from local database"]);
            }
            else if (!contextDidSave)
            {
                completionHandler(NO, nil);
            }
            else
                completionHandler(YES, nil);
        }];
    }
    else
    {
        completionHandler(YES, [NSError errorWithMessage:@"No phones match the given identifier"]);
    }
    
}

+ (void)changePhoneEntityWithIdentifier:(NSString *)identifier withCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler
{
    Phone *phone = [Phone MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"uniqueID == %@", identifier]];
    
    if (phone)
    {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext)
        {
            phone.lostStatus = [NSNumber numberWithBool:![phone.lostStatus boolValue]];
        }
        completion:^(BOOL contextDidSave, NSError * _Nullable error)
        {
            if (error)
            {
                completionHandler(NO, [NSError errorWithMessage:@"Could not change the status of the given phone"]);
            }
            else if (!contextDidSave)
            {
                completionHandler(NO, nil);
            }
            else
                completionHandler(YES, nil);
        }];
    }
    else
    {
        completionHandler(YES, [NSError errorWithMessage:@"No phones match the given identifier"]);
    }
}

@end
