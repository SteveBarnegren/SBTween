//
//  SBTActionInterpolate.h
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTAction.h"
#import "SBTEasing.h"

typedef double (^SBTTimingFunction)(double t);



@interface SBTActionInterpolate : SBTAction

@property (nonatomic, strong) NSString *variableName;


@property (nonatomic, copy) SBTTimingFunction timingFunction;

// Creation (Duration)

-(instancetype)initWithVariableName:(NSString*)name doubleValue:(double)doubleValue duration:(double)duration;
-(instancetype)initWithVariableName:(NSString*)name vec2Value:(SBTVec2)vec2Value duration:(double)duration;
-(instancetype)initWithVariableName:(NSString*)name vec3Value:(SBTVec3)vec3Value duration:(double)duration;
-(instancetype)initWithVariableName:(NSString*)name vec4Value:(SBTVec4)vec4Value duration:(double)duration;

// Creation (Speed)

-(instancetype)initWithVariableName:(NSString*)name doubleValue:(double)doubleValue speed:(double)speed;
-(instancetype)initWithVariableName:(NSString*)name vec2Value:(SBTVec2)vec2Value speed:(double)speed;
-(instancetype)initWithVariableName:(NSString*)name vec3Value:(SBTVec3)vec3Value speed:(double)speed;
-(instancetype)initWithVariableName:(NSString*)name vec4Value:(SBTVec4)vec4Value speed:(double)speed;

// Timing / Easing
-(void)setTimingFunctionWithMode:(SBTTimingMode)timingMode;


@end
