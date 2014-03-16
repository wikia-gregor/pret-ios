//
//  PRETHomeView
//  pret-ios 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 15.03.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import "PRETHomeView.h"
#import "MapKit/MapKit.h"

@implementation PRETHomeView {

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }

    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor grayColor];
    [self addSubview:self.mapView];

    self.zoomInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zoomInButton setImage:[UIImage imageNamed:@"zoom_in_btn"] forState:UIControlStateNormal];
    self.zoomInButton.hidden = YES;
    [self.zoomInButton sizeToFit];
    [self addSubview:self.zoomInButton];

    self.zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zoomOutButton setImage:[UIImage imageNamed:@"zoom_out_btn"] forState:UIControlStateNormal];
    self.zoomOutButton.hidden = NO;
    [self.zoomOutButton sizeToFit];
    [self addSubview:self.zoomOutButton];
}

- (void)layoutSubviews {
    self.mapView.frame = CGRectMake(
            0,
            0,
            CGRectGetWidth(self.bounds),
            CGRectGetHeight(self.bounds) - 44.0f
    );

    CGPoint zoomButtonCenter = CGPointMake(
            CGRectGetWidth(self.bounds) - 30,
            100
    );

    self.zoomInButton.center = zoomButtonCenter;
    self.zoomOutButton.center = zoomButtonCenter;
}

#pragma mark - Getters
- (MKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    }

    return _mapView;
}


@end