//
//  PRETReportCategoryViewController
//  pret-ios 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 16.03.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import "PRETReportCategoryViewController.h"
#import "PRETReportCategoryView.h"

@interface PRETReportCategoryViewController()

@property (nonatomic, strong) PRETReportCategoryView *reportCategoryView;
@property (nonatomic, strong) UIBarButtonItem *backBarButton;

@end


@implementation PRETReportCategoryViewController {

}

- (void)loadView {
    self.view = self.reportCategoryView;
    self.navigationItem.leftBarButtonItem = self.backBarButton;
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {

}

#pragma mark -
- (PRETReportCategoryView *)reportCategoryView {
    if (_reportCategoryView == nil) {
        _reportCategoryView = [[PRETReportCategoryView alloc] initWithFrame:CGRectZero];
    }

    return _reportCategoryView;
}

#pragma mark -
- (UIBarButtonItem *)backBarButton {
    if (_backBarButton == nil) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [backButton sizeToFit];

        _backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }

    return _backBarButton;
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

@end