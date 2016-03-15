//
//  TestDrawView.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "TestDrawView.h"
#import "SBTActionInterpolate.h"
#import "SBTActionSequence.h"
#import "SBTScheduler.h"
#import "SBTActionGroup.h"

#define kRadius 5

@interface TestDrawView ()
@property float xPos;
@property float yPos;
@property float radius;
@end

@implementation TestDrawView

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

-(void)runAnimation{
    
    // Start values
    self.xPos = kRadius;
    self.yPos = self.frame.size.height/2;
    self.radius = kRadius;
    
    // Move Right
    __weak __typeof__(self) weakSelf = self;
    SBTActionInterpolate *moveRightAction = [[SBTActionInterpolate alloc]initWithUpdateBlock:^(double t) {
        
        float start = 0;
        float end = self.frame.size.width - kRadius*2;
        
        weakSelf.xPos = start + (end - start) * t;
        [weakSelf setNeedsDisplay];
        
    } duration:5];
    [moveRightAction setTimingFunctionWithMode:SBTTimingModeEaseExponentialInOut];
    
    // Move Up
    SBTActionInterpolate *moveUpAction = [[SBTActionInterpolate alloc]initWithUpdateBlock:^(double t) {
        
        float start = self.frame.size.height/2;
        float end = 0;
        
        weakSelf.yPos = start + (end - start) * t;
        [weakSelf setNeedsDisplay];
        
    } duration:2];
    [moveUpAction setTimingFunctionWithMode:SBTTimingModeEaseExponentialInOut];
    
    // Expand
    SBTActionInterpolate *expandAction = [[SBTActionInterpolate alloc]initWithUpdateBlock:^(double t) {
        
        float start = kRadius;
        float end = kRadius * 3;
        
        weakSelf.radius = start + (end - start) * t;
        [weakSelf setNeedsDisplay];
        
    } duration:2];
    [expandAction setTimingFunctionWithMode:SBTTimingModeEaseExponentialOut];
    
    // Right and up
    SBTActionSequence *rightAndUpSequence = [[SBTActionSequence alloc]initWithActions:@[moveRightAction, moveUpAction]];
    
    // Move Up
    SBTActionInterpolate *moveToCentreAction = [[SBTActionInterpolate alloc]initWithUpdateBlock:^(double t) {
        
        float startX = self.frame.size.width - kRadius*2;
        float endX = self.frame.size.width/2;
        
        float startY = 0;
        float endY = self.frame.size.width/2;
        
        weakSelf.xPos = startX + (endX - startX) * t;
        weakSelf.yPos = startY + (endY - startY) * t;

        [weakSelf setNeedsDisplay];
        
    } duration:5];
    [moveUpAction setTimingFunctionWithMode:SBTTimingModeEaseExponentialInOut];
    
    // Expand
    SBTActionInterpolate *expandAction2 = [[SBTActionInterpolate alloc]initWithUpdateBlock:^(double t) {
        
        float start = kRadius * 3;
        float end = kRadius * 10;
        
        weakSelf.radius = start + (end - start) * t;
        [weakSelf setNeedsDisplay];
        
    } duration:10];
    [expandAction setTimingFunctionWithMode:SBTTimingModeLinear];

    
    // Group
    SBTActionGroup *toCentreGroup = [[SBTActionGroup alloc]initWithActions:@[moveToCentreAction, expandAction2]];
    
    // Whole ssequence
    SBTActionSequence *wholeSequence = [[SBTActionSequence alloc]initWithActions:@[rightAndUpSequence, toCentreGroup]];
    
    // Schedule
    [[SBTScheduler sharedScheduler]runAction:wholeSequence];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // clear background
    [[UIColor blackColor]set];
    [[UIBezierPath bezierPathWithRect:rect]fill];
    
    // Draw circle
    [[UIColor blueColor]set];
    
    CGRect circleRect;
    circleRect.origin.x = self.xPos;
    circleRect.origin.y = self.yPos;
    circleRect.size = CGSizeMake(self.radius*2, self.radius*2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [path fill];
}

@end
