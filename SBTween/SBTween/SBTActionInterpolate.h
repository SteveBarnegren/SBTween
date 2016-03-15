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
-(instancetype)initWithUpdateBlock:(SBTUpdateBlock)updateBlock duration:(double)duration;

// Timing
-(void)setTimingFunctionWithMode:(SBTTimingMode)timingMode;


@end
