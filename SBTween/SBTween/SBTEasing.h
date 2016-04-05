//
//  SBTEasing.h
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SBTTimingModeLinear,
    
    SBTTimingModeEaseSineIn,
    SBTTimingModeEaseSineOut,
    SBTTimingModeEaseSineInOut,
    
    SBTTimingModeEaseExponentialIn,
    SBTTimingModeEaseExponentialOut,
    SBTTimingModeEaseExponentialInOut,
    
    SBTTimingModeEaseBackIn,
    SBTTimingModeEaseBackOut,
    SBTTimingModeEaseBackInOut,
    
    SBTTimingModeEaseBounceIn,
    SBTTimingModeEaseBounceOut,
    SBTTimingModeEaseBounceInOut,
    
    SBTTimingModeEaseElasticIn,
    SBTTimingModeEaseElasticOut,
    SBTTimingModeEaseElasticInOut,
    
} SBTTimingMode;

@interface SBTEasing : NSObject

+(double (^)(double t))timingFunctionWithMode:(SBTTimingMode)timingMode;

#pragma mark - Ease Sine

+(double)easeSineIn:(double)t;
+(double)easeSineOut:(double)t;
+(double)easeSineInOut:(double)t;

#pragma mark - Ease Exponential

+(double)easeExponentialIn:(double)t;
+(double)easeExponentialOut:(double)t;
+(double)easeExponentialInOut:(double)t;

#pragma mark - Ease Back

+(double)easeBackIn:(double)t;
+(double)easeBackOut:(double)t;
+(double)easeBackInOut:(double)t;

#pragma mark - Ease Bounce

+(double)easeBounceIn:(double)t;
+(double)easeBounceOut:(double)t;
+(double)easeBounceInOut:(double)t;

#pragma mark - Ease Elastic

+(double)easeElasticIn:(double)t;
+(double)easeElasticOut:(double)t;
+(double)easeElasticInOut:(double)t;

@end
