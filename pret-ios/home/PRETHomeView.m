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
}

- (void)layoutSubviews {
    self.mapView.frame = CGRectMake(
            0,
            0,
            CGRectGetWidth(self.bounds),
            CGRectGetHeight(self.bounds) - 44.0f
    );
}

#pragma mark - Getters
- (MKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    }

    return _mapView;
}


@end