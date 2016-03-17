//
//  SBTActionInterpolate.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionInterpolate.h"
#import "SBTEasing.h"
#import "SBTContext.h"

@interface SBTActionInterpolate ()
@property (nonatomic, strong) NSString *variableName;
@property double doubleValue;
@end

@implementation SBTActionInterpolate

#pragma mark - Creation

-(instancetype)initWithUpdateBlock:(SBTUpdateBlock)updateBlock duration:(double)duration{
    
    if (self = [super init]) {
        self.updateBlock = updateBlock;
        self.duration = duration;
    }
    return self;
}


-(instancetype)initWithVariableName:(NSString*)name doubleValue:(double)value duration:(double)duration{
    
    if (self = [super init]) {
        self.duration = duration;
        self.variableName = [NSString stringWithString:name];
        self.doubleValue = value;
    }
    return self;
}

-(void)actionWillStart{
    [super actionWillStart];
    self.startValue = [self.context variableWithName:self.variableName].doubleValue;
}

#pragma mark - Update

-(void)updateWithTime:(double)t{
    
    t = MAX(0, t);
    t = MIN(1, t);
    
    if (self.timingFunction) {
        t = self.timingFunction(t);
    }
    
    if (self.context) {
        // We can cache the variable in order to reduce the number of calls to the dictionary
        SBTVariable *variable = [self.context variableWithName:self.variableName];
        variable.doubleValue = self.startValue + ((self.doubleValue - self.startValue) * t);
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
