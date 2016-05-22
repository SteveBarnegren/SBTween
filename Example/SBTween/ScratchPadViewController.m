//
//  ScratchPadViewController.m
//  SBTween
//
//  Created by Steve Barnegren on 18/05/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

/*
 ScratchPadViewController is just being used as a place to quickly write supporting code for development.
 */

#import "ScratchPadViewController.h"
#import "SBTween.h"

#define kVariableName @"HelloThere"

@interface ScratchPadViewController ()
@property (nonatomic, strong) SBTContext *animationContext;
@property (nonatomic, strong) SBTScheduledAction *scheduledAction;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@end

@implementation ScratchPadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // Label
    self.label = [[UILabel alloc]init];
    [self.view addSubview:self.label];
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    // Button
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:@"Stop" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    __weak __typeof__(self) weakSelf = self;
    
    self.animationContext = [[SBTContext alloc]init];
    SBTVariable *variable = [[SBTVariable alloc]initWithName:kVariableName vec2Value:SBTVec2Make(0, 0)];
    [self.animationContext addVariable:variable];
    
    SBTActionInterpolate *interpolateAction = [[SBTActionInterpolate alloc]initWithVariableName:kVariableName vec2Value:SBTVec2Make(200, 200) duration:10];
    
    self.scheduledAction = [self.animationContext addAction:interpolateAction reverse:NO updateBlock:^{
        
        SBTVariable *variable = [weakSelf.animationContext variableWithName:kVariableName];
        SBTVec2 value = variable.value.vec2Value;
        weakSelf.label.text = [NSString stringWithFormat:@"%f/%f", value.x, value.y];
        
    } startRunning:YES];

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    // Label
    {
        CGRect frame = self.view.bounds;
        frame.size.height /= 2;
        self.label.frame = frame;
    }
    
    // button
    [self.button sizeToFit];
    self.button.frame = CGRectMake(0,
                                   self.view.bounds.size.height - self.button.frame.size.height - 16,
                                   self.view.bounds.size.width,
                                   self.button.frame.size.height + 16);
    
    
}

-(void)buttonPressed{
    NSLog(@"button pressed");
    
    [self.animationContext removeScheduledAction:self.scheduledAction];
    
}

@end
