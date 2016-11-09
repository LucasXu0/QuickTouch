//
//  MainViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/7.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "MainViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "SpecialKeyViewController.h"
#import "CustomShortCutViewController.h"

#define cellID @"commandTypesCell"

@interface MainViewController () <GCDAsyncUdpSocketDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *kcopyButton;
@property (nonatomic, strong) UIButton *kpasteButton;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray *commandTypes;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据源
    self.commandTypes = @[@"Command Without Function",@"Command With One Function",@"Special Key",@"Custom Key"];
    
    [self.view addSubview:self.mainTableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commandTypes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = self.commandTypes[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch ((int)indexPath.row) {
        case 0:{
            OneViewController *oneVC = [OneViewController new];
            oneVC.title = @"One";
            [self.navigationController pushViewController:oneVC animated:NO];
        }
            break;
        case 1:{
            TwoViewController *twoVC = [TwoViewController new];
            twoVC.title = @"Two";
            [self.navigationController pushViewController:twoVC animated:NO];
        }
            break;
        case 2:{
            SpecialKeyViewController *specialKeyVC = [SpecialKeyViewController new];
            specialKeyVC.title = @"Special";
            [self.navigationController pushViewController:specialKeyVC animated:NO];
        }
            break;
        case 3:{
            CustomShortCutViewController *customVC = [CustomShortCutViewController new];
            customVC.title = @"Custom";
            [self.navigationController pushViewController:customVC animated:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Getter & Setter
-(UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:cellID];
    }
    return _mainTableView;
}
@end
