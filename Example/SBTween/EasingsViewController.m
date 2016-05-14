//
//  EasingsViewController.m
//  SBTween
//
//  Created by Steve Barnegren on 11/05/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "EasingsViewController.h"
#import "EasingAnimationCell.h"
#import "SBTween.h"

@interface EasingsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SBTContext *context;
@property double interpolationAmount;

@end

@implementation EasingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init Properties
    self.interpolationAmount = 0;
    
    // TableView
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.frame = [UIScreen mainScreen].bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([EasingAnimationCell class]) bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NSStringFromClass([EasingAnimationCell class])];
    
    // Context
    self.context = [[SBTContext alloc]init];
    NSString *variableName = @"Linear interpolator";
    SBTVariable *variable = [[SBTVariable alloc]initWithName:variableName doubleValue:0];
    [self.context addVariable:variable];
    
    // Action
    SBTActionInterpolate *action = [[SBTActionInterpolate alloc]initWithVariableName:variableName doubleValue:1 duration:2];
    [action setTimingFunctionWithMode:SBTTimingModeLinear];
    SBTActionYoYo *yoyoAction = [[SBTActionYoYo alloc]initWithAction:action];
    SBTActionRepeat *repeatAction = [[SBTActionRepeat alloc]initWithAction:yoyoAction numRepeats:1000];
    
    __weak __typeof__(self) weakSelf = self;
    [self.context addAction:action reverse:NO updateBlock:^{
        [weakSelf actionCallBack];
    } startRunning:YES];
    
    //Reload
    [self.tableView reloadData];
    
}

-(void)actionCallBack{
    
    SBTVariable *variable = [self.context variableWithName:@"Linear interpolator"];
    self.interpolationAmount = variable.value.doubleValue;
    NSLog(@"call back value: %f", self.interpolationAmount);
    
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        
        if ([cell isKindOfClass:[EasingAnimationCell class]]) {
            [((EasingAnimationCell*)cell)updateWithTime:self.interpolationAmount];
        }
    }
    
}

#pragma mark - UITableView Datasource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EasingAnimationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EasingAnimationCell class])];
    cell.timingMode = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


@end
