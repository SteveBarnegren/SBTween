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
@property (nonatomic, copy) SBTValue *startValue;
@property (nonatomic, copy) SBTValue *targetValue;
@property BOOL useSpeedBasedDuration;
@property double speed;
@end

@implementation SBTActionInterpolate

#pragma mark - Creation (Duration)

-(instancetype)initWithVariableName:(NSString*)name doubleValue:(double)doubleValue duration:(double)duration{
    if (self = [super init]) {
        self.duration = duration;
        self.variableName = [NSString stringWithString:name];
        self.targetValue = [SBTValue valueWithDouble:doubleValue];
    }
    return self;
}

-(instancetype)initWithVariableName:(NSString*)name vec2Value:(SBTVec2)vec2Value duration:(double)duration{
    if (self = [super init]) {
        self.duration = duration;
        self.variableName = [NSString stringWithString:name];
        self.targetValue = [SBTValue valueWithVec2:vec2Value];
    }
    return self;
}

-(instancetype)initWithVariableName:(NSString*)name vec3Value:(SBTVec3)vec3Value duration:(double)duration{
    if (self = [super init]) {
        self.duration = duration;
        self.variableName = [NSString stringWithString:name];
        self.targetValue = [SBTValue valueWithVec3:vec3Value];
    }
    return self;
}

-(instancetype)initWithVariableName:(NSString*)name vec4Value:(SBTVec4)vec4Value duration:(double)duration{
    if (self = [super init]) {
        self.duration = duration;
        self.variableName = [NSString stringWithString:name];
        self.targetValue = [SBTValue valueWithVec4:vec4Value];
    }
    return self;
}

#pragma mark - Creation (Speed)

-(instancetype)initWithVariableName:(NSString*)name doubleValue:(double)doubleValue speed:(double)speed{
    if (self = [super init]) {
        self.speed = speed;
        self.useSpeedBasedDuration = YES;
        self.variableName = [NSString stringWithString:name];
        self.targetValue = [SBTValue valueWithDouble:doubleValue];
    }
    return self;
}

-(instancetype)initWithVariableName:(NSString*)name vec2Value:(SBTVec2)vec2Value speed:(double)speed{
    if (self = [super init]) {
        self.speed = speed;
        self.useSpeedBasedDuration = YES;
        self.variableName = [NSString stringWithString:name];
        self.targetValue = [SBTValue valueWithVec2:vec2Value];
    }
    return self;
}

-(instancetype)initWithVariableName:(NSString*)name vec3Value:(SBTVec3)vec3Value speed:(double)speed{
    if (self = [super init]) {
        self.speed = speed;
        self.useSpeedBasedDuration = YES;
        self.variableName = [NSString stringWithString:name];
        self.targetValue = [SBTValue valueWithVec3:vec3Value];
    }
    return self;
}

-(instancetype)initWithVariableName:(NSString*)name vec4Value:(SBTVec4)vec4Value speed:(double)speed{
    if (self = [super init]) {
        self.speed = speed;
        self.useSpeedBasedDuration = YES;
        self.variableName = [NSString stringWithString:name];
        self.targetValue = [SBTValue valueWithVec4:vec4Value];
    }
    return self;
}

#pragma mark - LifeCycle

-(void)actionWillStart{
    [super actionWillStart];
   // NSLog(@"get start value!");
    //self.startValue = [self.context variableWithName:self.variableName].value;
    
    // Check that start and end value types match
    NSAssert2(self.startValue.type == self.targetValue.type,
              @"Action and Variable types must match! (Action has data type %@, but variable has type %@)",
              SBTValueTypeToString(self.targetValue.type),
              SBTValueTypeToString(self.startValue.type));
}

#pragma mark - Setup values and variables state

-(void)calculateValuesWithVariables:(NSMutableDictionary*)variables{

    SBTVariable *variable = variables[self.variableName];
    
    if (!variable) {
        SBTVariable *contextVariable = [self.context variableWithName:self.variableName];
        NSAssert(contextVariable, @"Action references varibale not added to context");
        variable = [contextVariable copy];
        variables[self.variableName] = variable;
    }
    
    self.startValue = [variable.value copy];
    variable.value = [self.targetValue copy];
    
    if (self.useSpeedBasedDuration) {
        [self setDurationBasedOnSpeed];
    }
}

-(void)setDurationBasedOnSpeed{
    
    switch (self.targetValue.type) {
        case SBTValueTypeDouble:
        {
            double dist = fabs(self.targetValue.doubleValue - self.startValue.doubleValue);
            self.duration = dist / self.speed;
        }
            break;
        case SBTValueTypeVec2:
        {
            double xDiff = self.targetValue.vec2Value.x - self.startValue.vec2Value.x;
            double yDiff = self.targetValue.vec2Value.y - self.startValue.vec2Value.y;
            double dist = sqrt((xDiff * xDiff) + (yDiff * yDiff));
            self.duration = fabs(dist / self.speed);
        }
            break;
        case SBTValueTypeVec3:
        {
            double xDiff = self.targetValue.vec3Value.x - self.startValue.vec3Value.x;
            double yDiff = self.targetValue.vec3Value.y - self.startValue.vec3Value.y;
            double zDiff = self.targetValue.vec3Value.z - self.startValue.vec3Value.z;
            double dist = sqrt((xDiff * xDiff) + (yDiff * yDiff) + (zDiff * zDiff));
            self.duration = fabs(dist / self.speed);
        }
            break;
        case SBTValueTypeVec4:
        {
            double xDiff = self.targetValue.vec4Value.x - self.startValue.vec4Value.x;
            double yDiff = self.targetValue.vec4Value.y - self.startValue.vec4Value.y;
            double zDiff = self.targetValue.vec4Value.z - self.startValue.vec4Value.z;
            double wDiff = self.targetValue.vec4Value.z - self.startValue.vec4Value.z;
            double dist = sqrt((xDiff * xDiff) + (yDiff * yDiff) + (zDiff * zDiff) + (wDiff * wDiff));
            self.duration = fabs(dist / self.speed);
        }
            break;
        default:
            NSAssert(NO, @"Unknown value type");
            break;
    }
}

-(void)setVariablesToEndStates{
    SBTVariable *variable = [self.context variableWithName:self.variableName];
    NSAssert1(variable, @"Caonnot find variable with name %@", self.variableName);
    variable.value = [self.targetValue copy];
}

#pragma mark - Update

-(void)updateWithTime:(double)t{
    
    if ([self.variableName isEqualToString:@"radius"]) {
        NSLog(@"GROW t: %f", t);
    }
        
    t = MAX(0, t);
    t = MIN(1, t);
    
    if (self.timingFunction) {
        t = self.timingFunction(t);
    }
    
    if (self.context) {
        // We can cache the variable in order to reduce the number of calls to the dictionary
        SBTVariable *variable = [self.context variableWithName:self.variableName];
        
        switch (self.targetValue.type) {
            case SBTValueTypeDouble: [self updateVariable:variable doubleValueWithTime:t]; break;
            case SBTValueTypeVec2: [self updateVariable:variable vec2ValueWithTime:t]; break;
            case SBTValueTypeVec3: [self updateVariable:variable vec3ValueWithTime:t]; break;
            case SBTValueTypeVec4: [self updateVariable:variable vec4ValueWithTime:t]; break;
            default:
                NSAssert(NO, @"Unknown value type");
                break;
        }
    }
    
    if (self.updateBlock) {
        self.updateBlock(t);
    }
}

-(void)updateVariable:(SBTVariable*)variable doubleValueWithTime:(double)t{
    double start = self.startValue.doubleValue;
    double target = self.targetValue.doubleValue;
    variable.value.doubleValue = start + ((target - start) * t);
}

-(void)updateVariable:(SBTVariable*)variable vec2ValueWithTime:(double)t{
    SBTVec2 start = self.startValue.vec2Value;
    SBTVec2 target = self.targetValue.vec2Value;
    variable.value.vec2Value = SBTVec2Make(start.x + ((target.x - start.x) * t),
                                           start.y + ((target.y - start.y) * t));
}

-(void)updateVariable:(SBTVariable*)variable vec3ValueWithTime:(double)t{
    SBTVec3 start = self.startValue.vec3Value;
    SBTVec3 target = self.targetValue.vec3Value;
    variable.value.vec3Value = SBTVec3Make(start.x + ((target.x - start.x) * t),
                                           start.y + ((target.y - start.y) * t),
                                           start.z + ((target.z - start.z) * t));
}

-(void)updateVariable:(SBTVariable*)variable vec4ValueWithTime:(double)t{
    SBTVec4 start = self.startValue.vec4Value;
    SBTVec4 target = self.targetValue.vec4Value;
    variable.value.vec4Value = SBTVec4Make(start.x + ((target.x - start.x) * t),
                                           start.y + ((target.y - start.y) * t),
                                           start.z + ((target.z - start.z) * t),
                                           start.w + ((target.w - start.w) * t));
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
