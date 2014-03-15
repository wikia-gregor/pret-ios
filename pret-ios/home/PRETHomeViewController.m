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

@interface PRETHomeViewController() <MKMapViewDelegate>

@property (nonatomic, strong) PRETHomeView *homeView;
@property (nonatomic, strong) UIBarButtonItem *menuBarButton;
@property (nonatomic, strong) UIBarButtonItem *filterBarButton;

@end

@implementation PRETHomeViewController {

}

- (void)loadView {
    // Home View
    self.view = [self homeView];

    // Navbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"FFD600"];

    // Menu button
    self.navigationItem.leftBarButtonItem = self.menuBarButton;

    // Toolbar
    self.filterBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(filterBarButtonTapped)];
    self.navigationController.toolbarHidden = NO;
    // toolbar color: 00AF5D
    // toolbar height: 98
    self.navigationController.toolbar.barTintColor = [UIColor colorWithHexString:@"00AF5D"];
    [self setToolbarItems:@[self.filterBarButton]];
}

- (void)viewWillAppear:(BOOL)animated {


}

- (void)viewDidAppear:(BOOL)animated {


}

#pragma mark - Private Getters
- (PRETHomeView *)homeView {
    if (_homeView == nil) {
        _homeView = [[PRETHomeView alloc] initWithFrame:CGRectZero];
        _homeView.mapView.delegate = self;
        _homeView.mapView.mapType = MKMapTypeHybrid;
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

//    [PFCloud callFunctionInBackground:@"getCategories" withParameters:@{} block:^(id object, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        }
//        else {
//            NSLog(@"Recived object: %@", object);
//        }
//    }];

    [self loadPoints];
}

- (void)menuButtonTapped {
    NSLog(@"Menu button tapped");
}

#pragma mark - API Calls
- (void)loadPoints {
    // Load SW NE points from map
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(self.homeView.mapView.visibleMapRect);
    NSLog(@"map rect: lat: %f lon: %f span:%f", region.center.latitude, region.center.longitude, region.span);

    CLLocationDegrees sw_lat = region.center.latitude - (region.span.latitudeDelta / 2);
    CLLocationDegrees sw_lon = region.center.longitude - (region.span.longitudeDelta / 2);

    CLLocationDegrees ne_lat = region.center.latitude + (region.span.latitudeDelta / 2);
    CLLocationDegrees ne_lon = region.center.longitude + (region.span.longitudeDelta / 2);

    NSLog(@"SW lat: %f lon: %f", sw_lat, sw_lon);
    NSLog(@"NE lat: %f lon: %f", ne_lat, ne_lon);

    PFGeoPoint *swPoint = [PFGeoPoint geoPointWithLatitude:sw_lat longitude:sw_lon];
    PFGeoPoint *nePoint = [PFGeoPoint geoPointWithLatitude:ne_lat longitude:ne_lon];

    [PFCloud callFunctionInBackground:@"getPointsInArea" withParameters:@{@"south_west": swPoint, @"north_east": nePoint} block:^(NSArray *object, NSError *error) {
        if (error) {
            NSLog(@"There was an error while loading nearest points: %@", error);
        }
        else {
            NSLog(@"points: %@", object);

            for (PFObject *point in object) {
                NSLog(@"Point data: %@", point);
            }
        }
    }];
}

#pragma mark - Map Delegate


@end