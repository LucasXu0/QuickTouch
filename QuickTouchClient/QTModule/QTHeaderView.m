//
//  QTHeaderView.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/21.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTHeaderView.h"

#define padding 15
#define appIconWidth 100

@interface QTHeaderView()

@property (nonatomic, strong) UIImageView *appIconView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UIButton *userNameButton;

@end

@implementation QTHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.layer setBorderColor:[[UIColor blueColor] CGColor]];
        [self.layer setBorderWidth:2.0f];
        [self configSubviews];
        RAC(self.appNameLabel, text) = RACObserve(self, appName);
        RAC(self.appIconView, image) = [RACObserve(self, appName) map:^UIImage *(NSString *appName) {
            return [UIImage imageNamed:appName];
        }];
        @weakify(self);
        [RACObserve(self, userName) subscribeNext:^(NSString *appName) {
            @strongify(self);
            [self.userNameButton setTitle:appName forState:UIControlStateNormal];
        }];
    }
    return self;
}

- (void)configSubviews{
    _appIconView = [UIImageView new];
    [self addSubview:_appIconView];
    [_appIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(padding);
        make.left.equalTo(self).with.offset(3 * padding);
        make.width.mas_equalTo(appIconWidth);
        make.height.mas_equalTo(appIconWidth);
    }];
    
    _appNameLabel = [UILabel new];
    [_appNameLabel setFont:[UIFont systemFontOfSize:25]];
    [self addSubview:_appNameLabel];
    [_appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_appIconView.mas_right).with.offset(3 * padding);
        make.top.equalTo(_appIconView.mas_top).with.offset(padding);
        make.height.mas_equalTo(30);
        make.right.equalTo(self).with.offset(-padding);
    }];
    
    _userNameButton = [UIButton new];
    _userNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_userNameButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:_userNameButton];
    [_userNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_appNameLabel.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(_appNameLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(15);
    }];
}

@end
