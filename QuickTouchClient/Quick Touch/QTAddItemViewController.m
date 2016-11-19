//
//  QTAddItemViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/18.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTAddItemViewController.h"
#import "QTAddCommnadViewController.h"
#import "QTAddItemModel.h"
#define QTItemCellID @"QTItemCellID"

@interface QTAddItemViewController () <UITableViewDelegate,UITableViewDataSource,QTAddCommnadViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *appNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) NSMutableArray<QTTypeModel *> *itemDataSource;

@end

@implementation QTAddItemViewController

- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Item" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToAddCommandVC)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemDataSource = [NSMutableArray new];

    _itemTableView.delegate = self;
    _itemTableView.dataSource = self;
    [_itemTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:QTItemCellID];
    
    [[_confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        QTAddItemModel *model = [QTAddItemModel new];
        model.desc = _descTextField.text;
        model.qtTypeModels = _itemDataSource;
        NSArray *itemDicts = [NSArray new];
        if((itemDicts = [[PINCache sharedCache] objectForKey:_appNameTextField.text])){
            NSMutableArray *mItems = [NSMutableArray arrayWithArray:itemDicts];
            [mItems addObject:model];
            [[PINCache sharedCache] setObject:mItems forKey:_appNameTextField.text];
        }else{
            [[PINCache sharedCache] setObject:@[model] forKey:_appNameTextField.text];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:QTQuickTouchVCReloadData object:nil];
        
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jumpToAddCommandVC{
    QTAddCommnadViewController *addCommandVC = [QTAddCommnadViewController new];
    addCommandVC.title = _appNameTextField.text;
    addCommandVC.delegate = self;
    [self.navigationController pushViewController:addCommandVC animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QTTypeModel *typeModel = _itemDataSource[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QTItemCellID];
    cell.textLabel.text = typeModel.qtDesc;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - QTAddCommnadViewControllerDelegate
- (void)commandDidAdd:(QTTypeModel *)model{
    [_itemDataSource addObject:model];
    [_itemTableView reloadData];
}

@end
