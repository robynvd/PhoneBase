//
//  PhoneBaseMapViewController.m
//  PhoneBase
//
//  Created by Robyn Van Deventer on 4/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "PhoneBaseMapViewController.h"
#import "PhoneBaseLostPhoneViewController.h"
#import "Phone.h"
#import "PBTableHeaderView.h"
#import "PBAnnotationView.h"
#import "GSLayoutGuideLength.h"
#import "UIView+Extended.h"

static NSString *const ReuseIdentifier = @"ReuseIdentifier";
static CGFloat const HeaderHeight = 20;

@interface PhoneBaseMapViewController() <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>

//Map view properties
@property (nonatomic, strong) MKMapView *mapView;

//Table view properties
@property (nonatomic, strong) UITableView *lostPhonesTableView;
@property (nonatomic, strong) NSLayoutConstraint *tableViewHeightConstraint;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) PBTableHeaderView *headerView;
@property (nonatomic) BOOL isCollapsed;

@end

@implementation PhoneBaseMapViewController

#pragma mark - Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fetchedResultsController = [Phone MR_fetchAllSortedBy:@"uniqueID"
                                                        ascending:YES
                                                    withPredicate:nil
                                                          groupBy:nil
                                                         delegate:self];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    self.title = @"All iPhones";
    self.view.backgroundColor = [UIColor clearColor];

    [self screenSetup];
    [self setupNavigationBar];
}

/**
 *  Sets up the view elements
 */
- (void)screenSetup
{
    self.isCollapsed = NO;
    
    //Map View
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsCompass = YES;
    [self.view addSubview:self.mapView];
    [self.mapView showAnnotations:self.fetchedResultsController.fetchedObjects animated:YES];
    
    //Lost Phones Table View
    self.lostPhonesTableView = [[UITableView alloc] init];
    self.lostPhonesTableView.backgroundColor = [UIColor clearColor];
    self.lostPhonesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lostPhonesTableView.dataSource = self;
    self.lostPhonesTableView.delegate = self;
    [self.mapView addSubview:self.lostPhonesTableView];
    
    //Blurred table view
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.lostPhonesTableView.backgroundView = blurView;
    
    //Constraints
    [NSLayoutConstraint activateConstraints:@[
        
        //Lost Phones Table View Constraints
        NSLayoutConstraintMakeAll(self.lostPhonesTableView, ALBottom, ALEqual, self.mapView, ALBottom, 1.0, 0, UILayoutPriorityRequired),
        self.tableViewHeightConstraint =  NSLayoutConstraintMakeAll(self.lostPhonesTableView, ALHeight, ALEqual, nil, ALHeight, 1.0, [AppearanceUtilities mapViewTableHeight], UILayoutPriorityRequired),
        NSLayoutConstraintMakeEqual(self.lostPhonesTableView, ALLeft, self.mapView),
        NSLayoutConstraintMakeEqual(self.lostPhonesTableView, ALRight, self.mapView),

    ]];
    
}

/**
 *  Setup for the navigation bar.
 *  Left button is user location tracking.
 *  Right button allows the user to add a new lost phone at their current location.
 */
- (void)setupNavigationBar
{
    MKUserTrackingBarButtonItem *trackingUserButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    self.navigationItem.leftBarButtonItem = trackingUserButton;
    UIImage *addLostPhoneButton = [UIImage imageNamed:@"LocationIcon"];
    UIBarButtonItem *addLostPhone = [[UIBarButtonItem alloc] initWithImage:addLostPhoneButton
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(addLostPhone)];

    self.navigationItem.rightBarButtonItem = addLostPhone;
}

/**
 *  Overrides the bottomLayoutGuide
 *
 *  @return The new length
 */
- (id<UILayoutSupport>)bottomLayoutGuide
{
    GSLayoutGuideLength *length = [[GSLayoutGuideLength alloc] initWithLength:self.lostPhonesTableView.frame.size.height];
    return length;
}

# pragma mark - Error handling

/**
 *  Presents an alert controller for specific/general errors
 *
 *  @param error The error passed in by completion handlers
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

#pragma mark - Actions

/**
 *  Attempts to add a new lost phone to the Firebase database.
 *  An alert controller will be presented on completion if it fails
 */
- (void)addLostPhone
{
    [[FirebaseManager sharedManager] addLostPhoneToDatabaseWithCompletionHandler:^(BOOL success, NSError *error)
    {
        if (error)
        {
            [self createAlertControllerWithError:error];
        }
        else if (!success)
        {
            [self createAlertControllerWithError:[NSError errorWithMessage:@"Something unexpected has occurred"]];
        }
    }];
}

/**
 *  Collapses and expands the table view.
 *  The height of the table view is animated to reflect the collapsing or
 *  expanding of the table view.
 *  The image of the button to collapse/expand is also animated to reflect the
 *  state the table view is in.
 */
- (void)collapseExpandLostPhonesTableView
{
    self.isCollapsed = !self.isCollapsed;
    
    CGFloat headerHeight = self.isCollapsed ? [AppearanceUtilities mapViewTableHeight] : HeaderHeight;
    NSString *buttonImage = self.isCollapsed ? @"downArrow" : @"upArrow";
    
        [UIView animateWithDuration:0.7
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.tableViewHeightConstraint.constant = headerHeight;
                             [self.lostPhonesTableView setNeedsLayout];
                             [self.lostPhonesTableView layoutIfNeeded];
                             [self.mapView setNeedsLayout];
                             [self.mapView layoutIfNeeded];
                         }
                         completion:^(BOOL finished)
                         {
                             [self.headerView.headerButton setImage:[[UIImage imageNamed:buttonImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                           forState:UIControlStateNormal];
                         }];
}

#pragma mark - Map View

/**
 *  Customises the view of the map view annotation.
 *  Returns nothing if the annotation is a user location.
 *  Creates a block that pushes a detail view controller for the annotation.
 *
 *  @param mapView    The current map view
 *  @param annotation A specific annotation
 *
 *  @return Returns a custom annotation view class
 */
- (PBAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == self.mapView.userLocation)
    {
        return nil;
    }
    else
    {
        PBAnnotationView *annotationView = (PBAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ReuseIdentifier];
        if (!annotationView)
        {
            annotationView = [[PBAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ReuseIdentifier];
        }
        
        __weak PhoneBaseMapViewController *weakself = self;
        annotationView.onTap = ^{
            Phone *phone = [Phone MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"uniqueID == %@", annotation.title]];
            
            weakself.lostPhonesTableView.hidden = YES;
            UIImage *imageOfView = [self.view convertViewToImage];
            weakself.lostPhonesTableView.hidden = NO;
            
            PhoneBaseLostPhoneViewController *phoneBaseViewController = [[PhoneBaseLostPhoneViewController alloc] initWithPhone:phone andImage:imageOfView];
            
            [weakself.navigationController pushViewController:phoneBaseViewController animated:YES];
        };

        return annotationView;
    }
}

/**
 *  Animates the alpha of the callout when a pin is tapped
 *
 *  @param mapView The current map view
 *  @param view    The annotation that was selected
 */
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(PBAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        [UIView animateWithDuration:0.1 animations:^{
            view.calloutView.alpha = 1;
        }];
    }
}

/**
 *  Animates the alpha of the callout when a pin is deselected
 *
 *  @param mapView The current map view
 *  @param view    The annotation that was deselected
 */
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(PBAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        [UIView animateWithDuration:0.1 animations:^{
            view.calloutView.alpha = 0;
        }];
    }
}

#pragma mark - Table View

/**
 *  Number of sections in the table view.
 *  This number is returned from a fetched results controller
 *
 *  @param tableView The lostPhonesTableView
 *
 *  @return The number of sections
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fetchedResultsController sections] count];
}

/**
 *  Number of rows in each section
 *  This number is returned from a fetched results controller
 *
 *  @param tableView The lostPhonesTableView
 *  @param section   The section number
 *
 *  @return The number of rows
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

/**
 *  Deqeues and creates a cell for each row
 *
 *  @param tableView The lostPhonesTableView
 *  @param indexPath The row
 *
 *  @return The cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

/**
 *  Configures the appearance of each cell
 *
 *  @param cell      The cell
 *  @param indexPath The row
 */
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Phone *phone = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.mapView showAnnotations:@[phone] animated:YES];
    cell.textLabel.text = phone.uniqueID;
    cell.detailTextLabel.text = phone.address;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBackgroundView.backgroundColor = [UIColor blackColor];
    cell.selectedBackgroundView = selectedBackgroundView;
}

/**
 *  Centres the map view and shows the callout of the corresponding phone
 *  that was tapped in the table view.
 *
 *  @param tableView The lostPhonesTableView
 *  @param indexPath The selected row
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Phone *phone = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([phone.latitude doubleValue], [phone.longitude doubleValue]) animated:YES];
    [self.mapView selectAnnotation:phone animated:YES];
}

/**
 *  Returns a custom header view for the table. 
 *  A button allows the table to be collapsed or expanded.
 *
 *  @param tableView The lostPhonesTableView
 *  @param section   The section to return a header for
 *
 *  @return The header view
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.headerView = [[PBTableHeaderView alloc] init];
    [self.headerView.headerButton addTarget:self
                                     action:@selector(collapseExpandLostPhonesTableView)
                           forControlEvents:UIControlEventTouchUpInside];

    return self.headerView;
}

/**
 *  The height for the lostPhonesTableView header
 *
 *  @param tableView The lostPhonesTableView
 *  @param section   The section number
 *
 *  @return The header height
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderHeight;
}

# pragma mark - NSFetchedResultsControllerDelegate

/**
 *  Begins updating the table view
 *
 *  @param controllerr The fetched results controller
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.lostPhonesTableView beginUpdates];
}

/**
 *  Inserts or removes sections that were changed
 *
 *  @param controller   The fetched results controller
 *  @param sectionInfo  The section info
 *  @param sectionIndex The section index
 *  @param type         The change type
 */
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.lostPhonesTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.lostPhonesTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

/**
 *  Inserts, updates or deletes phones that were changed
 *
 *  @param controller   The fetched results controller
 *  @param anObject     The phone that changed
 *  @param indexPath    The row
 *  @param type         The change type
 *  @param newIndexPath The new index path
 */
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.lostPhonesTableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [self.mapView showAnnotations:@[anObject] animated:YES];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.mapView removeAnnotation:anObject];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.mapView removeAnnotation:anObject];
            [self.mapView showAnnotations:@[anObject] animated:YES];
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

/**
 *  Finishes updating the table view
 *
 *  @param controller The fetched results controller
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.lostPhonesTableView endUpdates];
}

@end
