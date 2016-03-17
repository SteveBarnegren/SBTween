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

#define kRadius 5

// Variable names
#define kVN_Position @"Position"

#define kVN_radius @"radius"

@interface TestDrawView ()
@property (nonatomic, strong) SBTContext *context;
@end

@implementation TestDrawView

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

-(void)runAnimation{
    
    __weak __typeof__(self) weakSelf = self;
    
    self.context = [[SBTContext alloc]init];
    NSArray *variables = @[
                           [[SBTVariable alloc]initWithName:kVN_Position vec2Value:SBTVec2Make(50, 50)],
                           [[SBTVariable alloc]initWithName:kVN_radius doubleValue:10.0f]
                           ];
    [self.context addVariables:variables];
    
    SBTActionInterpolate *move = [[SBTActionInterpolate alloc]initWithVariableName:kVN_Position
                                                                         vec2Value:SBTVec2Make(300, 300)
                                                                          duration:5];
    
    SBTActionInterpolate *grow = [[SBTActionInterpolate alloc]initWithVariableName:kVN_radius doubleValue:30 duration:3];
    
    SBTActionGroup *moveAndGrow = [[SBTActionGroup alloc]initWithActions:@[move, grow]];

    [self.context addAction:moveAndGrow updateBlock:^{
        [weakSelf setNeedsDisplay];
    } startRunning:YES];
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


@end
