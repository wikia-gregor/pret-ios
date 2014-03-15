//
//  PRETHomeViewController
//  pret-ios 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 15.03.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "PRETHomeViewController.h"
#import "PRETHomeView.h"
#import "Parse/Parse.h"
#import "MapKit/MapKit.h"
#import "UIColor+WikiaColorTools.h"
#import "MKMapView+ZoomLevel.h"

@interface PRETHomeViewController() <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) PRETHomeView *homeView;
@property (nonatomic, strong) UIBarButtonItem *menuBarButton;
@property (nonatomic, strong) UIBarButtonItem *filterBarButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL dynamicPointsUpdateEnabled;

@end

@implementation PRETHomeViewController {

}

- (void)loadView {
    self.dynamicPointsUpdateEnabled = NO;

    // Home View
    self.view = [self homeView];

    // Navbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"FFD600"];

    // Menu button
    self.navigationItem.leftBarButtonItem = self.menuBarButton;

    // Toolbar
    self.filterBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(filterBarButtonTapped)];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barTintColor = [UIColor colorWithHexString:@"2D6B6B"];
    [self setToolbarItems:@[self.filterBarButton]];

    // Location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Private Getters
- (PRETHomeView *)homeView {
    if (_homeView == nil) {
        _homeView = [[PRETHomeView alloc] initWithFrame:CGRectZero];
        _homeView.mapView.delegate = self;
    }

    return _homeView;
}

- (UIBarButtonItem *)menuBarButton {
    if (_menuBarButton == nil) {
        _menuBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(menuButtonTapped)];
    }

    return _menuBarButton;
}

#pragma mark - Bar Button Actions
- (void)filterBarButtonTapped {
    NSLog(@"Button tapped");
}

- (void)menuButtonTapped {
    NSLog(@"Menu button tapped");
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
    NSLog(@"View for annotation: %@", annotation);
    return nil;
}

#pragma mark - Location Manager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    [self.homeView.mapView setCenterCoordinate:newLocation.coordinate zoomLevel:10 animated:YES];
    self.dynamicPointsUpdateEnabled = YES;
    [self loadPoints];
}


@end