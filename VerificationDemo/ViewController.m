//
//  ViewController.m
//  VerificationDemo
//
//  Created by DengJinlong on 12/29/15.
//  Copyright © 2015 dengjinlong. All rights reserved.
//

#import "ViewController.h"
#import "PAVerifycell.h"
#import "PAVerifyCellModel.h"
#import "RACCommand.h"
#import "EXTScope.h"
#import "RACSignal+Category.h"
#import "RACSignal+Operations.h"
#import "NSObject+RACDeallocating.h"
#import "RACSubscriptingAssignmentTrampoline.h"
#import "NSObject+RACPropertySubscribing.h"

#define PAVerifyCellIdentifier @"com.pa.verifyCell"

@interface ViewController () <UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) PAVerifyCellModel *cellModel;
@property (copy, nonatomic) NSString *phoneNumber;
@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Demo";
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[PAVerifycell class] forCellReuseIdentifier:PAVerifyCellIdentifier];
    
    RAC(self, phoneNumber) = RACObserve(self, cellModel.inputText);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (UITableView *)tableView {
    if (nil == _tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectZero style:(UITableViewStylePlain)];
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; // 消除多余我空cell
        tableView.separatorColor = [UIColor lightGrayColor];
        self.tableView = tableView;
    }
    return _tableView;
}

- (PAVerifyCellModel *)cellModel {
    if (nil == _cellModel) {
        PAVerifyCellModel *cellModel = [[PAVerifyCellModel alloc] init];
        cellModel.inputText = @"";
        cellModel.rac_countDown = nil;
        @weakify(self);
        cellModel.verifyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(PAVerifyCellModel *b_cellModel) {
            @strongify(self);
            [self.view endEditing:YES];
            // if phone invalid return error
            
            b_cellModel.rac_countDown = [[RACSignal countdownSignal] replayLast];
            
            return [[self rac_requestVerifyCodeForPhone:self.phoneNumber] takeUntil:self.rac_willDeallocSignal];
        }];
         
        self.cellModel = cellModel;
    }
    return _cellModel;
}

- (RACSignal *)rac_requestVerifyCodeForPhone:(NSString *)phone {
    return [RACSignal empty];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PAVerifycell *cell = [tableView dequeueReusableCellWithIdentifier:PAVerifyCellIdentifier];
    
    [cell configCellWithCellModel:self.cellModel];
    
    return cell;
}

@end
