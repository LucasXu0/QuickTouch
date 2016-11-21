//
//  QTFooterView.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/21.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTFooterView.h"

#define buttonWidth 40

@interface QTFooterView()

@property (nonatomic, strong) UIButton *brightnessButton;
@property (nonatomic, strong) UIButton *volumeButton;

@end

@implementation QTFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.layer setBorderColor:[[UIColor blueColor] CGColor]];
        [self.layer setBorderWidth:2.0f];
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews{
    _brightnessButton = [UIButton new];
    [_brightnessButton setImage:[UIImage imageNamed:@"brightness_mid"] forState:UIControlStateNormal];
    [self addSubview:_brightnessButton];
    [_brightnessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonWidth);
    }];

    _volumeButton = [UIButton new];
    [_volumeButton setImage:[UIImage imageNamed:@"volume_mid"] forState:UIControlStateNormal];
    [self addSubview:_volumeButton];
    [_volumeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonWidth);
    }];

}

@end
