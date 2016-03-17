//
//  SBTActionInterpolate.h
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTAction.h"

typedef double (^SBTTimingFunction)(double t);

typedef enum : NSUInteger {
    SBTTimingModeLinear,
    SBTTimingModeEaseExponentialIn,
    SBTTimingModeEaseExponentialOut,
    SBTTimingModeEaseExponentialInOut,
} SBTTimingMode;

@interface SBTActionInterpolate : SBTAction

@property (nonatomic, copy) SBTTimingFunction timingFunction;

// Creation
-(instancetype)initWithVariableName:(NSString*)name doubleValue:(double)doubleValue duration:(double)duration;
-(instancetype)initWithVariableName:(NSString*)name vec2Value:(SBTVec2)vec2Value duration:(double)duration;
-(instancetype)initWithVariableName:(NSString*)name vec3Value:(SBTVec3)vec3Value duration:(double)duration;
-(instancetype)initWithVariableName:(NSString*)name vec4Value:(SBTVec4)vec4Value duration:(double)duration;

// Timing
-(void)setTimingFunctionWithMode:(SBTTimingMode)timingMode;


@end
