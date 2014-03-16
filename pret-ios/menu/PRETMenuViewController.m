//
//  PRETMenuViewController
//  pret-ios 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 16.03.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import "PRETMenuViewController.h"
#import "PRETMenuView.h"

@interface PRETMenuViewController()

@property (nonatomic, strong) PRETMenuView *menuView;

@end

@implementation PRETMenuViewController {

}

- (void)loadView {
    self.view = self.menuView;
}

- (void)viewDidAppear:(BOOL)animated {

}

#pragma mark - Menu View
- (PRETMenuView *)menuView {
    if (_menuView == nil) {
        _menuView = [[PRETMenuView alloc] initWithFrame:CGRectZero];
    }

    return _menuView;
}

@end