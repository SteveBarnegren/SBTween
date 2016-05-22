//
//  ExamplesViewController.m
//  SBTween
//
//  Created by Steve Barnegren on 11/05/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "ExamplesViewController.h"
#import "EasingsViewController.h"
#import "ScratchPadViewController.h"

@interface ExamplesViewController ()

@end

@implementation ExamplesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // show the easings view controller
    EasingsViewController *viewController = [[EasingsViewController alloc]init];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    viewController.view.frame = [UIScreen mainScreen].bounds;
//
    // Show the scratch pad view controller
//    ScratchPadViewController *viewController = [[ScratchPadViewController alloc]init];
//    [self addChildViewController:viewController];
//    [self.view addSubview:viewController.view];
//    viewController.view.frame = [UIScreen mainScreen].bounds;
    
}

@end
