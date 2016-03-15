//
//  SBTActionInterpolate.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionInterpolate.h"
#import "SBTEasing.h"

@implementation SBTActionInterpolate

#pragma mark - Creation

-(instancetype)initWithUpdateBlock:(SBTUpdateBlock)updateBlock duration:(double)duration{
    
    if (self = [super init]) {
        self.updateBlock = updateBlock;
        self.duration = duration;
    }
    return self;
}

#pragma mark - Update

-(void)updateWithTime:(double)t{
    
    t = MAX(0, t);
    t = MIN(1, t);
    
    if (self.timingFunction) {
        t = self.timingFunction(t);
    }
    
    if (self.updateBlock) {
        self.updateBlock(t);
    }
    
}

#pragma mark - Timing

-(void)setTimingFunctionWithMode:(SBTTimingMode)timingMode{
    
    switch (timingMode) {
            // Linear
        case SBTTimingModeLinear:
            self.timingFunction = nil;
            break;
            // Ease Exponential
        case SBTTimingModeEaseExponentialIn:
            self.timingFunction = ^double(double t){
                return [SBTEasing easeExponentialIn:t];
            };
            break;
        case SBTTimingModeEaseExponentialOut:
            self.timingFunction = ^double(double t){
                return [SBTEasing easeExponentialOut:t];
            };
            break;
        case SBTTimingModeEaseExponentialInOut:
            self.timingFunction = ^double(double t){
                return [SBTEasing easeExponentialInOut:t];
            };
            break;
        default:
            break;
    }
}


@end
