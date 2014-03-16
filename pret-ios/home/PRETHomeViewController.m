//
//  PRETHomeViewController
//  pret-ios 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 15.03.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MSDynamicsDrawerViewController/MSDynamicsDrawerViewController.h>
#import "PRETHomeViewController.h"
#import "PRETHomeView.h"
#import "Parse/Parse.h"
#import "MapKit/MapKit.h"
#import "UIColor+WikiaColorTools.h"
#import "MKMapView+ZoomLevel.h"
#import "PRETAppDelegate.h"
#import "PRETReportCategoryViewController.h"

@interface PRETHomeViewController() <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) PRETHomeView *homeView;
@property (nonatomic, strong) UIBarButtonItem *menuBarButton;
@property (nonatomic, strong) UIBarButtonItem *findBarButton;
@property (nonatomic, strong) UIBarButtonItem *filterBarButton;
@property (nonatomic, strong) UIBarButtonItem *reportBarButton;
@property (nonatomic, strong) UIBarButtonItem *statsBarButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL dynamicPointsUpdateEnabled;
@property (nonatomic, assign) BOOL zoomIn;
@property (nonatomic, assign) CLLocationCoordinate2D currentUserCoordinate;

@end

@implementation PRETHomeViewController {

}

- (void)loadView {
    self.dynamicPointsUpdateEnabled = NO;
    self.zoomIn = NO;

    // Home View
    self.view = [self homeView];



    // Zoom buttons
    [self.homeView.zoomInButton addTarget:self action:@selector(toggleZoom) forControlEvents:UIControlEventTouchUpInside];
    [self.homeView.zoomOutButton addTarget:self action:@selector(toggleZoom) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    // Menu button
    self.navigationItem.leftBarButtonItem = self.menuBarButton;

    // Find button
    self.navigationItem.rightBarButtonItem = self.findBarButton;

    // Navbar
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    // Toolbar
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barTintColor = [UIColor colorWithHexString:@"2d6b6b"];

    // Some flexible element
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    // Put all buttons into toolbar
    [self setToolbarItems:@[self.filterBarButton, flexibleItem, self.reportBarButton, flexibleItem, self.statsBarButton]];
}

- (void)viewDidAppear:(BOOL)animated {

    // Location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Private Getters
- (PRETHomeView *)homeView {
    if (_homeView == nil) {
        _homeView = [[PRETHomeView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, 320, 370)];
        _homeView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _homeView.mapView.delegate = self;
    }

    return _homeView;
}

- (UIBarButtonItem *)menuBarButton {
    if (_menuBarButton == nil) {
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(0, 0, 38, 31);
        [menuButton addTarget:self action:@selector(menuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [menuButton setImage:[UIImage imageNamed:@"hamburger_btn"] forState:UIControlStateNormal];

        _menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    }

    return _menuBarButton;
}

- (UIBarButtonItem *)findBarButton {
    if (_findBarButton == nil) {
        UIButton *findButton = [UIButton buttonWithType:UIButtonTypeCustom];
        findButton.frame = CGRectMake(0, 0, 66, 31);
        [findButton addTarget:self action:@selector(findButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [findButton setImage:[UIImage imageNamed:@"find_btn"] forState:UIControlStateNormal];

        _findBarButton = [[UIBarButtonItem alloc] initWithCustomView:findButton];
    }

    return _findBarButton;
}

- (UIBarButtonItem *)filterBarButton {
    if (_filterBarButton == nil) {
        // Filter button
        UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [filterButton setImage:[UIImage imageNamed:@"filter_icon"] forState:UIControlStateNormal];
        [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
        [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [filterButton addTarget:self action:@selector(filterBarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [filterButton sizeToFit];

        _filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    }

    return _filterBarButton;
}

- (UIBarButtonItem *)reportBarButton {
    if (_reportBarButton == nil) {
        UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reportButton addTarget:self action:@selector(reportButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [reportButton setImage:[UIImage imageNamed:@"report_btn"] forState:UIControlStateNormal];
        reportButton.frame = CGRectMake(0, -19, 103, 81);

        UIView *buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 103, 80)];
        [buttonContainerView addSubview:reportButton];
        _reportBarButton = [[UIBarButtonItem alloc] initWithCustomView:buttonContainerView];
    }

    return _reportBarButton;
}

- (UIBarButtonItem *)statsBarButton {
    if (_statsBarButton == nil) {
        UIButton *statsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [statsButton setImage:[UIImage imageNamed:@"stat_icon"] forState:UIControlStateNormal];
        [statsButton setTitle:@"Stats" forState:UIControlStateNormal];
        [statsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [statsButton addTarget:self action:@selector(statsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [statsButton sizeToFit];

        _statsBarButton = [[UIBarButtonItem alloc] initWithCustomView:statsButton];
    }

    return _statsBarButton;
}

#pragma mark - Bar Button Actions
- (void)filterBarButtonTapped {
    NSLog(@"Button tapped");
}

- (void)menuButtonTapped {
    NSLog(@"Menu button tapped");

    PRETAppDelegate *appDelegate = (PRETAppDelegate *)[[UIApplication sharedApplication] delegate];

    if (appDelegate.drawerViewController.paneState == MSDynamicsDrawerPaneStateClosed) {
        [appDelegate.drawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen animated:YES allowUserInterruption:YES completion:^{
            NSLog(@"Opened!");
        }];
    }
    else {
        [appDelegate.drawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:^{
            NSLog(@"Closed");
        }];
    }
}

- (void)findButtonTapped {
    NSLog(@"find button tapped");
}

- (void)reportButtonTapped {
    NSLog(@"Report button!");

    PRETReportCategoryViewController *reportCategoryViewController = [[PRETReportCategoryViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:reportCategoryViewController animated:YES];
}

- (void)statsButtonTapped {
    NSLog(@"Stats button tapped");
}

- (void)toggleZoom {
    NSLog(@"toggle Zoom");

    if (self.zoomIn) {
        self.zoomIn = NO;
        [self.homeView.mapView setCenterCoordinate:self.currentUserCoordinate zoomLevel:14 animated:YES];
        self.homeView.zoomInButton.hidden = YES;
        self.homeView.zoomOutButton.hidden = NO;
    }
    else {
        self.zoomIn = YES;
        [self.homeView.mapView setCenterCoordinate:self.currentUserCoordinate zoomLevel:9 animated:YES];
        self.homeView.zoomInButton.hidden = NO;
        self.homeView.zoomOutButton.hidden = YES;
    }
}

#pragma mark - API Calls
- (void)loadPoints {
    // Load SW NE points from map
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(self.homeView.mapView.visibleMapRect);
    NSLog(@"map rect: lat: %f lon: %f span:%f", region.center.latitude, region.center.longitude, region.span);

    if (region.span.latitudeDelta > 5 || region.span.longitudeDelta > 5) {
        NSLog(@"Too big span to load points!");
        return;
    }

    CLLocationDegrees sw_lat = region.center.latitude - (region.span.latitudeDelta / 2);
    CLLocationDegrees sw_lon = region.center.longitude - (region.span.longitudeDelta / 2);

    CLLocationDegrees ne_lat = region.center.latitude + (region.span.latitudeDelta / 2);
    CLLocationDegrees ne_lon = region.center.longitude + (region.span.longitudeDelta / 2);

    NSLog(@"SW lat: %f lon: %f", sw_lat, sw_lon);
    NSLog(@"NE lat: %f lon: %f", ne_lat, ne_lon);

    PFGeoPoint *swPoint = [PFGeoPoint geoPointWithLatitude:sw_lat longitude:sw_lon];
    PFGeoPoint *nePoint = [PFGeoPoint geoPointWithLatitude:ne_lat longitude:ne_lon];

    [PFCloud callFunctionInBackground:@"getPointsInArea" withParameters:@{@"south_west": swPoint, @"north_east": nePoint} block:^(NSArray *reportsCollection, NSError *error) {
        if (error) {
            NSLog(@"There was an error while loading nearest points: %@", error);
        }
        else {
            NSLog(@"points: %@", reportsCollection);

            if ([reportsCollection count]) {
                [self.homeView.mapView removeAnnotations:self.homeView.mapView.annotations];

                for (PFObject *point in reportsCollection) {
                    NSLog(@"Point data: %@", point);

                    MKPointAnnotation *reportAnnotation = [[MKPointAnnotation alloc] init];
                    PFGeoPoint *geoPoint = [point valueForKey:@"geo_point"];
                    CLLocationCoordinate2D geoCoordinates;
                    geoCoordinates.latitude = geoPoint.latitude;
                    geoCoordinates.longitude = geoPoint.longitude;
                    reportAnnotation.coordinate = geoCoordinates;
                    reportAnnotation.title = [point valueForKey:@"name"];

                    [self.homeView.mapView addAnnotation:reportAnnotation];
                }
            }
        }
    }];
}

#pragma mark - Map Delegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"MAP region changed...");
    if (animated) {
        NSLog(@"Animated");
    }

    if (self.dynamicPointsUpdateEnabled) {
        [self loadPoints];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pret"];
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"flag_ico"];
    annotationView.frame = CGRectMake(0, 0, 34, 50);
    return annotationView;
}

#pragma mark - Location Manager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    self.currentUserCoordinate = newLocation.coordinate;

    [self.homeView.mapView setCenterCoordinate:newLocation.coordinate zoomLevel:14 animated:YES];
    self.dynamicPointsUpdateEnabled = YES;
    [self loadPoints];
}


@end