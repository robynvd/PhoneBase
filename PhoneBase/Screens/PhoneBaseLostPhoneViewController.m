//
//  PhoneBaseLostPhoneViewController.m
//  PhoneBase
//
//  Created by Robyn Van Deventer on 4/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "PhoneBaseLostPhoneViewController.h"

static CGFloat const VerticalSpacing = 75;

@interface PhoneBaseLostPhoneViewController()

@property (nonatomic, strong) UILabel *lostFoundLabel;
@property (nonatomic, strong) UISwitch *lostFoundSwitch;

@property (nonatomic, strong) Phone *phone;
@property (nonatomic, strong) UIImage *imageOfView;

@end

@implementation PhoneBaseLostPhoneViewController

# pragma mark - Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.phone.uniqueID;

    [self screenSetup];
    [self initialiseLostFoundSwitch];
}

/**
 *  Handles the setup of the view elements
 */
- (void)screenSetup
{
    //Blurred background
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = self.imageOfView;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.frame = backgroundImageView.frame;
    [backgroundImageView addSubview:blurView];
    [self.view addSubview:backgroundImageView];
    
    //Phone unique identifier
    UILabel *identifierLabel = [[UILabel alloc] init];
    identifierLabel.text = self.phone.uniqueID;
    identifierLabel.font = [UIFont detailViewUniqueIDFont];
    identifierLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:identifierLabel];
    
    //Phone image
    UIImage *phoneImage = [UIImage imageNamed:@"iPhone"];
    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:phoneImage];
    [self.view addSubview:phoneImageView];
    
    //Phone address
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = self.phone.address;
    addressLabel.font = [UIFont detailViewLabelFont];
    addressLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:addressLabel];
    
    //Lost/Found indicator
    self.lostFoundLabel = [[UILabel alloc] init];
    self.lostFoundLabel.font = [UIFont detailViewLabelFont];
    self.lostFoundLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.lostFoundLabel];
    
    //Lost/Found switch
    self.lostFoundSwitch = [[UISwitch alloc] init];
    [self.lostFoundSwitch addTarget:self
                             action:@selector(lostFoundSwitchToggled:)
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.lostFoundSwitch];
    
    //Constraints
    [NSLayoutConstraint activateConstraints:@[
                                              
        //Identifer Label Constraints
        NSLayoutConstraintMakeInset(identifierLabel, ALTop, VerticalSpacing),
        NSLayoutConstraintMakeEqual(identifierLabel, ALCenterX, self.view),
                                              
        //Phone Image Constraints
        NSLayoutConstraintMakeVSpace(identifierLabel, phoneImageView, [AppearanceUtilities detailViewVerticalSpacing]),
        NSLayoutConstraintMakeEqual(phoneImageView, ALCenterX, self.view),
                                              
        //Address Label Constraints
        NSLayoutConstraintMakeVSpace(phoneImageView, addressLabel, [AppearanceUtilities detailViewAddressSpacing]),
        NSLayoutConstraintMakeEqual( addressLabel, ALCenterX, self.view),
                                              
        //Lost and Found Label Constraints
        NSLayoutConstraintMakeVSpace(addressLabel, self.lostFoundLabel, [AppearanceUtilities detailViewVerticalSpacing]),
        NSLayoutConstraintMakeEqual(self.lostFoundLabel, ALCenterX, self.view),
                                              
        //Lost and Found Switch Constraints
        NSLayoutConstraintMakeVSpace(self.lostFoundLabel, self.lostFoundSwitch, 5),
        NSLayoutConstraintMakeEqual(self.lostFoundSwitch, ALCenterX, self.view),
        NSLayoutConstraintMakeInset(self.lostFoundSwitch, ALBottom, -20),
    ]];
}

/**
 *  Initalises the toggle switch based on the lostStatus of the phone
 */
- (void)initialiseLostFoundSwitch
{
    [self.lostFoundSwitch setOn:![self.phone.lostStatus boolValue] animated:NO];
    [self lostFoundLabelToggle];
}

/**
 *  Sets the label text based on the phone status
 */
- (void)lostFoundLabelToggle
{
    if (self.lostFoundSwitch.on)
    {
        [self.lostFoundLabel setText:@"Found"];
    }
    else
    {
        [self.lostFoundLabel setText:@"Missing"];
    }
}

#pragma mark - Actions

/**
 *  Attempts to update the status of the phone in the Firebase database.
 *  Will call an alert controller on completion if it fails to update.
 *
 *  @param sender The switch the user has toggled
 */
- (void)lostFoundSwitchToggled:(UISwitch *)sender
{
    [[FirebaseManager sharedManager] updateStatus:self.lostFoundSwitch.on ofPhone:self.phone.uniqueID withCompletionHandler:^(BOOL success, NSError *error)
    {
        if (!success && error)
        {
            [self createAlertControllerWithError:error];
        }
        else if (!success && !error)
        {
            [self createAlertControllerWithError:[NSError errorWithMessage:@"Something unexpected has occurred"]];
        }
    }];
    
    [self lostFoundLabelToggle];
}

# pragma mark - Error handling

/**
 *  Presents an alert controller for specific/general errors
 *
 *  @param error The error passed in from completion handlers
 */
- (void)createAlertControllerWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:error.domain
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Overriding the init

- (instancetype)initWithPhone:(Phone *)phone andImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.phone =  phone;
        self.imageOfView = image;
    }
    return self;
}

@end
