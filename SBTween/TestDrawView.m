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
#import "SBTActionGroup.h"
#import "SBTActionDelay.h"
#import "SBTVariable.h"
#import "SBTContext.h"
#import "SBTActionRepeat.h"
#import "SBTActionCallBlock.h"
#import "SBTActionYoyo.h"
#import "SBTActionSetValue.h"

#define kRadius 5

// Variable names
#define kVN_Position @"Position"

#define kVN_radius @"radius"

@interface TestDrawView ()
@property (nonatomic, strong) SBTContext *context;
@property (nonatomic, strong) SBTScheduledAction *scheduledAction;
@end

@implementation TestDrawView

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
/*
-(void)runAnimation{
    
    __weak __typeof__(self) weakSelf = self;
    
    SBTActionCallBlock *callBlock1 = [[SBTActionCallBlock alloc]initWithBlock:^(BOOL isReverse) {
        NSLog(@"CALL BLOCK 1 (%@)", isReverse ? @"Reverse" : @"Forward");
    }];
    SBTActionCallBlock *callBlock2 = [[SBTActionCallBlock alloc]initWithBlock:^(BOOL isReverse) {
        NSLog(@"CALL BLOCK 2 (%@)", isReverse ? @"Reverse" : @"Forward");
    }];
    SBTActionCallBlock *callBlock3 = [[SBTActionCallBlock alloc]initWithBlock:^(BOOL isReverse) {
        NSLog(@"CALL BLOCK 3 (%@)", isReverse ? @"Reverse" : @"Forward");
    }];
    SBTActionCallBlock *callBlock4 = [[SBTActionCallBlock alloc]initWithBlock:^(BOOL isReverse) {
        NSLog(@"CALL BLOCK 4 (%@)", isReverse ? @"Reverse" : @"Forward");
    }];
    SBTActionCallBlock *callBlock5 = [[SBTActionCallBlock alloc]initWithBlock:^(BOOL isReverse) {
        NSLog(@"CALL BLOCK 5 (%@)", isReverse ? @"Reverse" : @"Forward");
    }];


    self.context = [[SBTContext alloc]init];
    NSArray *variables = @[
                           [[SBTVariable alloc]initWithName:kVN_Position vec2Value:SBTVec2Make(50, 50)],
                           [[SBTVariable alloc]initWithName:kVN_radius doubleValue:10.0f]
                           ];
    [self.context addVariables:variables];
    
    SBTActionInterpolate *move = [[SBTActionInterpolate alloc]initWithVariableName:kVN_Position
                                                                         vec2Value:SBTVec2Make(100, 100)
                                                                          duration: 5];
    [move setTimingFunctionWithMode:SBTTimingModeEaseElasticOut];
    
    SBTActionInterpolate *grow = [[SBTActionInterpolate alloc]initWithVariableName:kVN_radius doubleValue:30 duration:3];
    [grow setBecomeActiveCallback:^{
        NSLog(@"Grow will become active");
    }];
    [grow setBecomeInactiveCallback:^{
        NSLog(@"Grow will become inactive");
    }];
    
    SBTActionGroup *moveAndGrowGRP = [[SBTActionGroup alloc]initWithActions:@[move, grow]];
    
    SBTActionSequence *moveAndGrowSequence = [[SBTActionSequence alloc]initWithActions:@[callBlock1, move, callBlock2, grow, callBlock3]];
    
    self.scheduledAction = [self.context addAction:moveAndGrowGRP reverse:NO updateBlock:^{
        [weakSelf setNeedsDisplay];
    } startRunning:NO];

//    [self.context addAction:moveAndGrowSequence updateBlock:^{
//        [weakSelf setNeedsDisplay];
//    } startRunning:YES];
    
    [self setNeedsDisplay];
}
 */

-(void)runAnimation{
    
    __weak __typeof__(self) weakSelf = self;
    
    SBTActionCallBlock *callBlock1 = [[SBTActionCallBlock alloc]initWithBlock:^(BOOL isReverse) {
        NSLog(@"CALL BLOCK 1 (%@)", isReverse ? @"Reverse" : @"Forward");
    }];
    SBTActionCallBlock *callBlock2 = [[SBTActionCallBlock alloc]initWithBlock:^(BOOL isReverse) {
        NSLog(@"CALL BLOCK 2 (%@)", isReverse ? @"Reverse" : @"Forward");
    }];
    SBTActionCallBlock *callBlock3 = [[SBTActionCallBlock alloc]initWithBlock:^(BOOL isReverse) {
        NSLog(@"CALL BLOCK 3 (%@)", isReverse ? @"Reverse" : @"Forward");
    }];
    SBTActionCallBlock *callBlock4 = [[SBTActionCallBlock alloc]initWithBlock:^(BOOL isReverse) {
        NSLog(@"CALL BLOCK 4 (%@)", isReverse ? @"Reverse" : @"Forward");
    }];
    SBTActionCallBlock *callBlock5 = [[SBTActionCallBlock alloc]initWithBlock:^(BOOL isReverse) {
        NSLog(@"CALL BLOCK 5 (%@)", isReverse ? @"Reverse" : @"Forward");
    }];
    
    
    self.context = [[SBTContext alloc]init];
    NSArray *variables = @[
                           [[SBTVariable alloc]initWithName:kVN_Position vec2Value:SBTVec2Make(50, 50)],
                           [[SBTVariable alloc]initWithName:kVN_radius doubleValue:10.0f]
                           ];
    [self.context addVariables:variables];
    
    SBTActionInterpolate *move = [[SBTActionInterpolate alloc]initWithVariableName:kVN_Position
                                                                         vec2Value:SBTVec2Make(100, 100)
                                                                          duration: 5];
    [move setTimingFunctionWithMode:SBTTimingModeEaseElasticOut];
    
    SBTActionInterpolate *grow = [[SBTActionInterpolate alloc]initWithVariableName:kVN_radius doubleValue:30 duration:1];
    [grow setBecomeActiveCallback:^{
        NSLog(@"Grow will become active");
    }];
    [grow setBecomeInactiveCallback:^{
        NSLog(@"Grow will become inactive");
    }];
    
    SBTActionGroup *moveAndGrowGRP = [[SBTActionGroup alloc]initWithActions:@[move]];
    [moveAndGrowGRP addAction:grow atEnd:YES];
    
    SBTActionSequence *moveAndGrowSequence = [[SBTActionSequence alloc]initWithActions:@[callBlock1, move, callBlock2, grow, callBlock3]];
    
    SBTActionInterpolate *moveToBottom =
    [[SBTActionInterpolate alloc]initWithVariableName:kVN_Position vec2Value:SBTVec2Make([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height * 0.9) duration:2];
    [moveToBottom setTimingFunctionWithMode:SBTTimingModeEaseExponentialInOut];
    
    SBTActionSetValue *setValueAction = [[SBTActionSetValue alloc]initWithVariableName:kVN_Position vec2Value:SBTVec2Make(175, 100)];
    
    SBTActionSequence *masterSequence = [[SBTActionSequence alloc]initWithActions:@[moveAndGrowGRP, moveToBottom]];
    
    SBTActionRepeat *sequenceRepeat = [[SBTActionRepeat alloc]initWithAction:masterSequence numRepeats:3];
    SBTActionYoYo *sequenceYoyo = [[SBTActionYoYo alloc]initWithAction:masterSequence];
    
    self.scheduledAction = [self.context addAction:sequenceYoyo reverse:NO updateBlock:^{
        [weakSelf setNeedsDisplay];
    } startRunning:YES];
    
    //    [self.context addAction:moveAndGrowSequence updateBlock:^{
    //        [weakSelf setNeedsDisplay];
    //    } startRunning:YES];
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.context) {
        return;
    }
    
    double xPos = [self.context variableWithName:kVN_Position].value.vec2Value.x;
    double yPos = [self.context variableWithName:kVN_Position].value.vec2Value.y;
    double radius = [self.context variableWithName:kVN_radius].value.doubleValue;
    
    // clear background
    [[UIColor blackColor]set];
    [[UIBezierPath bezierPathWithRect:rect]fill];
    
    // Draw circle
    [[UIColor blueColor]set];
    
    CGRect circleRect;
    circleRect.origin.x = xPos;
    circleRect.origin.y = yPos;
    circleRect.size = CGSizeMake(radius, radius);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [path fill];
}

-(void)sliderChangedToValue:(float)value{
    
    [self.scheduledAction updateWithTime:value];
    
}



@end
