//
//  ViewController.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "ViewController.h"
#import "TestDrawView.h"

@interface ViewController ()
@property (nonatomic, strong) TestDrawView *testDrawView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testDrawView = [[TestDrawView alloc]init];
    [self.view addSubview:self.testDrawView];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.testDrawView.frame = self.view.bounds;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(runAnimation) withObject:nil afterDelay:2];
}

-(void)runAnimation{
    NSLog(@"***** Run Animation *****");
    [self.testDrawView runAnimation];
}

@end
