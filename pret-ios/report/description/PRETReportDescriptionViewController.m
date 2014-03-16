//
//  PRETReportDescriptionViewController
//  pret-ios 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 16.03.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import <Parse/Parse.h>
#import "PRETReportDescriptionViewController.h"
#import "PRETReportDescriptionView.h"
#import "UIImage+Resize.h"

@interface PRETReportDescriptionViewController() <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) PRETReportDescriptionView *reportDescriptionView;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) UIBarButtonItem *backBarButton;
@property (nonatomic, strong) UIBarButtonItem *nextBarButton;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, assign) CLLocationCoordinate2D reportCoordinate;

@end

@implementation PRETReportDescriptionViewController {

}
- (instancetype)initWithCategory:(NSString *)categoryId reportCoordinate:(CLLocationCoordinate2D)reportCoordinate {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.categoryId = categoryId;
        self.reportCoordinate = reportCoordinate;
    }

    return self;
}


- (void)loadView {
    self.view = self.reportDescriptionView;
    self.reportDescriptionView.textView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.leftBarButtonItem = self.backBarButton;
    self.navigationItem.rightBarButtonItem = self.nextBarButton;
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.reportDescriptionView.textView becomeFirstResponder];
}

#pragma mark -
- (PRETReportDescriptionView *)reportDescriptionView {
    if (_reportDescriptionView == nil) {
        _reportDescriptionView = [[PRETReportDescriptionView alloc] initWithFrame:CGRectZero];
        _reportDescriptionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }

    return _reportDescriptionView;
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

- (UIBarButtonItem *)nextBarButton {
    if (_nextBarButton == nil) {
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [nextButton setImage:[UIImage imageNamed:@"next_btn"] forState:UIControlStateNormal];
        [nextButton sizeToFit];

        _nextBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    }

    return _nextBarButton;
}

- (void)nextButtonTapped {
    [self grabPhoto];
}

#pragma mark -
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"end editing");
}


#pragma mark -
- (void)grabPhoto {
    [self.navigationController presentViewController:self.imagePickerController animated:YES completion:^{
        NSLog(@"photo picker should be visible");
    }];
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.delegate = self;
    }

    return _imagePickerController;
}

#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    NSLog(@"Photo taken!");
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"picker should be hided");
    }];

    UIImage *resizedImage = [image resizedImageToSize:CGSizeMake(640, 480)];
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
    PFFile *imageFile = [PFFile fileWithName:@"reportImage.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFGeoPoint *geoPoint = [[PFGeoPoint alloc] init];
        geoPoint.longitude = self.reportCoordinate.longitude;
        geoPoint.latitude = self.reportCoordinate.latitude;

        NSDictionary *parseCallParams = @{
                @"name": self.reportDescriptionView.textView.text,
                @"geo_point": geoPoint,
                @"category_id": self.categoryId,
                @"status_id": @"ZxC08aColc",
                @"description": self.reportDescriptionView.textView.text,
                @"file": imageFile
        };

        [PFCloud callFunctionInBackground:@"addReport" withParameters:parseCallParams block:^(id object, NSError *error) {
            if (error) {
                NSLog(@"There was an error: %@", error);
            }
            else {
                NSLog(@"SUCCESS!!! Report added!");
            }

            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
}


@end