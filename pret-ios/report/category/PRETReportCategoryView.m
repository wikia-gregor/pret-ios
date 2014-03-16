//
//  PRETReportCategoryView
//  pret-ios 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 16.03.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import "PRETReportCategoryView.h"
#import "UIColor+WikiaColorTools.h"

@interface PRETReportCategoryView()

@property (nonatomic, strong) UIView *infoBackgroundView;

@end

@implementation PRETReportCategoryView {

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }

    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];

    self.infoBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.infoBackgroundView.backgroundColor = [UIColor colorWithHexString:@"59c39d"];
    [self addSubview:self.infoBackgroundView];

    self.mainInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.mainInfoLabel setText:@"Please pick category"];
    [self.mainInfoLabel setTextColor:[UIColor whiteColor]];
    [self.mainInfoLabel setFont:[UIFont boldSystemFontOfSize:26.0f]];
    self.mainInfoLabel.textAlignment = NSTextAlignmentCenter;
    [self.infoBackgroundView addSubview:self.mainInfoLabel];

    self.infoSubtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.infoSubtitleLabel setText:@"(It will help us generate better statistics)"];
    [self.infoSubtitleLabel setTextColor:[UIColor whiteColor]];
    self.infoSubtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.infoBackgroundView addSubview:self.infoSubtitleLabel];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    self.tableView.separatorColor = [UIColor colorWithHexString:@"585656"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
    [self addSubview:self.tableView];
}

- (void)layoutSubviews {
    self.infoBackgroundView.frame = CGRectMake(
            0,
            64,
            CGRectGetWidth(self.bounds),
            90
    );

    self.mainInfoLabel.frame = CGRectMake(
            0,
            15,
            CGRectGetWidth(self.bounds),
            30
    );

    self.infoSubtitleLabel.frame = CGRectMake(
            0,
            CGRectGetMaxY(self.mainInfoLabel.frame) + 6,
            CGRectGetWidth(self.bounds),
            30
    );

    self.tableView.frame = CGRectMake(
            0,
            CGRectGetMaxY(self.infoBackgroundView.frame),
            CGRectGetWidth(self.bounds),
            300
    );
}

@end