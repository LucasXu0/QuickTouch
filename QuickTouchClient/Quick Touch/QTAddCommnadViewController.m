//
//  QTAddCommnadViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/18.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTAddCommnadViewController.h"

@interface QTAddCommnadViewController ()
@property (weak, nonatomic) IBOutlet UITextField *qtTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UILabel *para1Label;
@property (weak, nonatomic) IBOutlet UILabel *para2Label;
@property (weak, nonatomic) IBOutlet UILabel *para3Label;
@property (weak, nonatomic) IBOutlet UILabel *para4Label;
@property (weak, nonatomic) IBOutlet UITextField *para1TextField;
@property (weak, nonatomic) IBOutlet UITextField *para2TextField;
@property (weak, nonatomic) IBOutlet UITextField *para3TextField;
@property (weak, nonatomic) IBOutlet UITextField *para4TextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (nonatomic, strong) QTTypeModel *typeModel;
@end

@implementation QTAddCommnadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_qtTypeTextField.rac_textSignal subscribeNext:^(NSString *type) {
        [self displayAllSubViews];
        switch ([type intValue]) {
            case 1:
                [self hiddenSubViews:@[@2,@3,@4]];
                self.para1Label.text = @"content";
                break;
            case 2:
                [self hiddenSubViews:@[@3,@4]];
                self.para1Label.text = @"content";
                self.para2Label.text = @"enter?";
                break;
            case 3:
                [self hiddenSubViews:@[@3,@4]];
                self.para1Label.text = @"func keys";
                self.para2Label.text = @"plain key";
                break;
            case 4:
                self.para1Label.text = @"sub menu item";
                self.para2Label.text = @"menu item";
                self.para3Label.text = @"menu";
                self.para4Label.text = @"menu bar";
                break;
            case 5:
                [self hiddenSubViews:@[@3,@4]];
                self.para1Label.text = @"system type";
                self.para2Label.text = @"paras";
                break;
            default:
                [self hiddenSubViews:@[@1,@2,@3,@4]];
                break;
        }
    }];
    
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        switch ([self.qtTypeTextField.text intValue]) {
            case 1:{
                QTSingleWordModel *singleWordModel = [QTSingleWordModel new];
                singleWordModel.content = self.para1TextField.text;
                QTTypeModel *model = [QTTypeModel new];
                model.qtType = QTSingleWord;
                model.qtDesc = self.descTextField.text;
                model.qtContent = singleWordModel;
                _typeModel = model;
            }
                break;
            case 2:{
                QTPureWordsModel *pureWordsModel = [QTPureWordsModel new];
                pureWordsModel.content = self.para1TextField.text;
                pureWordsModel.enter = self.para2TextField.text;
                QTTypeModel *model = [QTTypeModel new];
                model.qtType = QTPureWords;
                model.qtDesc = self.descTextField.text;
                model.qtContent = pureWordsModel;
                _typeModel = model;
            }
                break;
            case 3:{
                QTShortCutsModel *shortCustModel = [QTShortCutsModel new];
                NSArray *array = [self.para1TextField.text componentsSeparatedByString:@"/"];
                shortCustModel.functionKeys = array;
                shortCustModel.plainKey = self.para2TextField.text;
                QTTypeModel *model = [QTTypeModel new];
                model.qtType = QTShortCuts;
                model.qtDesc = self.descTextField.text;
                model.qtContent = shortCustModel;
                _typeModel = model;
            }
                break;
            case 4:{
                QTClickMenuItemModel *clickMenuItemModel = [QTClickMenuItemModel new];
                clickMenuItemModel.subMenuItem = self.para1TextField.text;
                clickMenuItemModel.menuItem = self.para2TextField.text;
                clickMenuItemModel.menu = self.para3TextField.text;
                clickMenuItemModel.menuBar = [self.para4TextField.text integerValue];
                clickMenuItemModel.appName = self.title;
                QTTypeModel *model = [QTTypeModel new];
                model.qtType = QTClickMenuItem;
                model.qtDesc = self.descTextField.text;
                model.qtContent = clickMenuItemModel;
                _typeModel = model;
            }
                break;
            case 5:{
                QTSystemEventModel *systemEventModel = [QTSystemEventModel new];
                systemEventModel.qtSystemEventType = [self.para1TextField.text integerValue];;
                systemEventModel.paras = self.para2TextField.text;
                QTTypeModel *model = [QTTypeModel new];
                model.qtType = QTSystemEvent;
                model.qtDesc = self.descTextField.text;
                model.qtContent = systemEventModel;
                _typeModel = model;
            }
                break;
            default:
                break;
        };
    }];
    
    [[_confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([self.delegate respondsToSelector:@selector(commandDidAdd:)]) {
            [self.delegate commandDidAdd:_typeModel];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (void)hiddenSubViews:(NSArray *)paras{
    for (NSNumber *i in paras) {
        if ([@1  isEqual: i]) {
            self.para1Label.hidden = YES;
            self.para1TextField.hidden = YES;
        }
        if ([@2  isEqual: i]) {
            self.para2Label.hidden = YES;
            self.para2TextField.hidden = YES;
        }
        if ([@3  isEqual: i]) {
            self.para3Label.hidden = YES;
            self.para3TextField.hidden = YES;
        }
        if ([@4  isEqual: i]) {
            self.para4Label.hidden = YES;
            self.para4TextField.hidden = YES;
        }
    }
}

- (void)displayAllSubViews{
    self.para1Label.hidden = NO;
    self.para1TextField.hidden = NO;
    self.para2Label.hidden = NO;
    self.para2TextField.hidden = NO;
    self.para3Label.hidden = NO;
    self.para3TextField.hidden = NO;
    self.para4Label.hidden = NO;
    self.para4TextField.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
