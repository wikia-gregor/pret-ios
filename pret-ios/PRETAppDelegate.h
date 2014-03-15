//
//  PRETAppDelegate.h
//  PRET
//
//  Created by Gregor on 15.03.2014.
//  Copyright (c) 2014 Wikia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PRETHomeViewController;

@interface PRETAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) PRETHomeViewController *homeViewController;

@end