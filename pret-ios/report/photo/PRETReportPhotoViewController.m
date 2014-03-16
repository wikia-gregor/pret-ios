//
//  PRETReportPhotoViewController
//  pret-ios 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 16.03.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import "PRETReportPhotoViewController.h"

@interface PRETReportPhotoViewController()

@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSString *reportDescription;

@end

@implementation PRETReportPhotoViewController {

}

- (instancetype)initWithCategory:(NSNumber *)categoryId description:(NSString *)reportDescription {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.categoryId = categoryId;
        self.reportDescription = reportDescription;
    }

    return self;
}

- (void)loadView {

}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated {

}

@end