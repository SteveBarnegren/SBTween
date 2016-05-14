//
//  EasingsViewController.m
//  SBTween
//
//  Created by Steve Barnegren on 11/05/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "EasingsViewController.h"
#import "EasingAnimationCell.h"
#import "EasingHeaderCell.h"
#import "SBTween.h"

#pragma mark - ***** EasingCellInfo *****

@interface EasingCellInfo : NSObject
@property SBTTimingMode timingMode;
@property (nonatomic, strong) NSString *name;
@end

@implementation EasingCellInfo

+(instancetype)infoWithTimingMode:(SBTTimingMode)timingMode name:(NSString*)name{
    
    EasingCellInfo *info = [[EasingCellInfo alloc]init];
    info.timingMode = timingMode;
    info.name = name;
    return info;
}

@end

#pragma mark - ***** EasingsViewController *****

@interface EasingsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellInfos;

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 30.0;
    
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([EasingHeaderCell class]) bundle:nil];
    [self.tableView registerNib:headerNib forCellReuseIdentifier:NSStringFromClass([EasingHeaderCell class])];
    
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
    //SBTActionYoYo *yoyoAction = [[SBTActionYoYo alloc]initWithAction:action];
    SBTActionRepeat *repeatAction = [[SBTActionRepeat alloc]initWithAction:action numRepeats:1000];
    
    __weak __typeof__(self) weakSelf = self;
    [self.context addAction:repeatAction reverse:NO updateBlock:^{
        [weakSelf actionCallBack];
    } startRunning:YES];
    
    //Reload
    [self createCellInfos];
    [self.tableView reloadData];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    const float topMargin = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    self.tableView.frame = CGRectMake(0,
                                      topMargin,
                                      self.view.frame.size.width,
                                      self.view.frame.size.height - topMargin);
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

-(void)createCellInfos{
    
    NSMutableArray *mutInfos = [[NSMutableArray alloc]init];
    
    [mutInfos addObject:@"Linear"];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeLinear name:@"Linear"]];
    [mutInfos addObject:@"Sine"];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseSineIn name:@"SineIn"]];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseSineOut name:@"SineOut"]];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseSineInOut name:@"SineInOut"]];
    [mutInfos addObject:@"Exponential"];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseExponentialIn name:@"ExponentialIn"]];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseExponentialOut name:@"ExponentialOut"]];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseExponentialInOut name:@"ExponentialInOut"]];
    [mutInfos addObject:@"Back"];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseBackIn name:@"BackIn"]];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseBackOut name:@"BackOut"]];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseBackInOut name:@"BackInOut"]];
    [mutInfos addObject:@"Bounce"];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseBounceIn name:@"BounceIn"]];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseBounceOut name:@"BounceOut"]];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseBounceInOut name:@"BounceInOut"]];
    [mutInfos addObject:@"Elastic"];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseElasticIn name:@"ElasticIn"]];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseElasticOut name:@"ElasticOut"]];
    [mutInfos addObject:[EasingCellInfo infoWithTimingMode:SBTTimingModeEaseElasticInOut name:@"ElasticInOut"]];
    
    self.cellInfos = [NSArray arrayWithArray:mutInfos];

}

#pragma mark - UITableView Datasource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id info = self.cellInfos[indexPath.row];
    
    if ([info isKindOfClass:[EasingCellInfo class]]) {
        
        EasingAnimationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EasingAnimationCell class])];
        cell.timingMode = ((EasingCellInfo*)info).timingMode;
        [cell setTitle:((EasingCellInfo*)info).name];
        return cell;
    }
    else{
        EasingHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EasingHeaderCell class])];
        cell.title = info;
        return cell;
    }

}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id info = self.cellInfos[indexPath.row];
    
    if ([info isKindOfClass:[EasingCellInfo class]]) {
        return 60;
    }
    else{
        return 30;
    }
    
}
 */


@end
