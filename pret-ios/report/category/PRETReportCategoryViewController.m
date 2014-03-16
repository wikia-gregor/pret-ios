//
//  PRETReportCategoryViewController
//  pret-ios 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 16.03.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "PRETReportCategoryViewController.h"
#import "PRETReportCategoryView.h"
#import "UIColor+WikiaColorTools.h"
#import "PRETReportDescriptionViewController.h"

@interface PRETReportCategoryViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PRETReportCategoryView *reportCategoryView;
@property (nonatomic, strong) UIBarButtonItem *backBarButton;
@property (nonatomic, assign) CLLocationCoordinate2D reportCoordinate;

@end


@implementation PRETReportCategoryViewController {

}
- (instancetype)initWitchReportCoordinate:(CLLocationCoordinate2D)reportCoordinate {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.reportCoordinate = reportCoordinate;
    }

    return self;
}


- (void)loadView {
    self.view = self.reportCategoryView;
    self.reportCategoryView.tableView.dataSource = self;
    self.reportCategoryView.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.leftBarButtonItem = self.backBarButton;
    self.navigationController.toolbarHidden = YES;
}

#pragma mark -
- (PRETReportCategoryView *)reportCategoryView {
    if (_reportCategoryView == nil) {
        _reportCategoryView = [[PRETReportCategoryView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, 320, 370)];
        _reportCategoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
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

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pret"];

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Vertical Signs";
            cell.imageView.image = [UIImage imageNamed:@"ico02_"];
            break;
        case 1:
            cell.textLabel.text = @"Horizontal Signs";
            cell.imageView.image = [UIImage imageNamed:@"ico01_"];
            break;
        case 2:
            cell.textLabel.text = @"Road holes";
            cell.imageView.image = [UIImage imageNamed:@"ico03_"];
            break;
        case 3:
            cell.textLabel.text = @"Street lights";
            cell.imageView.image = [UIImage imageNamed:@"ico04_"];
            break;
        case 4:
            cell.textLabel.text = @"Others";
            cell.imageView.image = [UIImage imageNamed:@"ico05_"];
            break;
        default:
            break;
    }

    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green_arrow"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PRETReportDescriptionViewController *reportDescriptionViewController = [[PRETReportDescriptionViewController alloc] initWithCategory:@"e6aqnUd1PQ" reportCoordinate:self.reportCoordinate];
    [self.navigationController pushViewController:reportDescriptionViewController animated:YES];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
}


@end