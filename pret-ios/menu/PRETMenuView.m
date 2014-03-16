//
//  PRETMenuView
//  pret-ios 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 16.03.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import "PRETMenuView.h"


@implementation PRETMenuView {

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }

    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor whiteColor];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainmenu"]];
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self addSubview:imageView];

//    UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
//    [test setText:@"testing text"];
//    [test setTextColor:[UIColor blueColor]];
//    [self addSubview:test];
}

@end