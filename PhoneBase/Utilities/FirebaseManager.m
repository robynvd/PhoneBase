//
//  FirebaseManager.m
//  PhoneBase
//
//  Created by Robyn Van Deventer on 23/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "FirebaseManager.h"
#import "CoreDataUtility.h"
#import <Firebase/Firebase.h>

@interface FirebaseManager()

@property (nonatomic, strong) Firebase *rootRef;
@property (nonatomic, strong) Firebase *phonesRef;

@end

@implementation FirebaseManager

+ (instancetype)sharedManager {
    static FirebaseManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[FirebaseManager alloc] init];
    });
    
    return _sharedManager;
}

/**
 *  Initialises the Firebase manager with the root reference and the phone reference
 *  that all phones are stored under.
 *
 *  @return Returns self
 */
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.rootRef = [[Firebase alloc] initWithUrl:@"https://incandescent-heat-1583.firebaseio.com/"];
        self.phonesRef = [self.rootRef childByAppendingPath:@"Phones"];
    }
    return self;
}

- (void)initialiseLostPhonesWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler
{
    [self.phonesRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot)
     {
         [CoreDataUtility changePhoneEntityWithIdentifier:snapshot.key withCompletionHandler:^(BOOL success, NSError *error)
          {
              completionHandler(success, error);
          }];
     }];
    
    [self.phonesRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot)
     {
         NSDictionary *dictionary = @{
                                      @"uniqueID" : snapshot.key,
                                      @"address" : snapshot.value[@"address"],
                                      @"lostStatus" : snapshot.value[@"lostStatus"],
                                      @"latitude" : snapshot.value[@"latitude"],
                                      @"longitude" : snapshot.value[@"longitude"],
                                      };
         
         [CoreDataUtility createPhoneEntityFromDictionary:dictionary withCompletionHandler:^(BOOL success, NSError *error)
          {
              completionHandler(success, error);
          }];
     }];
    
    [self.phonesRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot)
     {
         [CoreDataUtility removePhoneEntityWithIdentifier:snapshot.key withCompletionHandler:^(BOOL success, NSError *error)
          {
              completionHandler(success, error);
          }];
     }];
    
    [self.phonesRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
     {
         if (!snapshot.hasChildren)
         {
             [CoreDataUtility removeAllPhonesWithCompletionHandler:^(BOOL success, NSError *error)
              {
                  completionHandler(success, error);
              }];
         }
     }];
}

- (void)addLostPhoneToDatabaseWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler
{
    [[LocationManager sharedManager] getAddressFromCurrentLocationWithCompletionHandler:^(NSString *address, CGFloat latitude, CGFloat longitude, NSError *error)
     {
         if (error)
         {
             completionHandler(NO, error);
         }
         else
         {
             NSDictionary *phone = @{
                                     @"address" : address,
                                     @"lostStatus" : @YES,
                                     @"latitude" : @(latitude),
                                     @"longitude" : @(longitude),
                                     };
             
             Firebase *phoneRef = [self.phonesRef childByAutoId];
             [phoneRef setValue:phone withCompletionBlock:^(NSError *error, Firebase *ref)
              {
                  if (error)
                  {
                      completionHandler(NO, [NSError errorWithMessage:@"Could not add lost phone to the database"]);
                  }
                  else
                      completionHandler(YES, nil);
              }];
         }
     }];
}

- (void)updateStatus:(BOOL)status ofPhone:(NSString *)identifier withCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler
{
    Firebase *phoneRef = [self.phonesRef childByAppendingPath:identifier];
    
    NSDictionary *changeStatus = @{
                                   @"lostStatus" : @(!status),
                                   };
    
    [phoneRef updateChildValues:changeStatus withCompletionBlock:^(NSError *error, Firebase *ref)
     {
         if (error)
         {
             completionHandler(NO, [NSError errorWithMessage:@"Could not update status of given phone"]);
         }
         else
             completionHandler(YES, nil);
     }];
}

@end
