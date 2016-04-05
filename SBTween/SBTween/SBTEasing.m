//
//  SBTEasing.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTEasing.h"

#define M_PI_X_2 (float)M_PI * 2.0f

#define kPERIOD 0.3

@implementation SBTEasing

+(double (^)(double t))timingFunctionWithMode:(SBTTimingMode)timingMode{
    
    switch (timingMode) {
            
            // Linear
        case SBTTimingModeLinear:
            return ^double(double t){
                return t;
            };
            break;
          
            // Ease Sine
        case SBTTimingModeEaseSineIn:
            return ^double(double t){
                return [SBTEasing easeSineIn:t];
            };
            break;
        case SBTTimingModeEaseSineOut:
            return ^double(double t){
                return [SBTEasing easeSineOut:t];
            };
            break;
        case SBTTimingModeEaseSineInOut:
            return ^double(double t){
                return [SBTEasing easeSineInOut:t];
            };
            break;
            
            // Ease Exponential
        case SBTTimingModeEaseExponentialIn:
            return ^double(double t){
                return [SBTEasing easeExponentialIn:t];
            };
            break;
        case SBTTimingModeEaseExponentialOut:
            return ^double(double t){
                return [SBTEasing easeExponentialOut:t];
            };
            break;
        case SBTTimingModeEaseExponentialInOut:
            return ^double(double t){
                return [SBTEasing easeExponentialInOut:t];
            };
            break;

            // Ease Back
        case SBTTimingModeEaseBackIn:
            return ^double(double t){
                return [SBTEasing easeBackIn:t];
            };
            break;
        case SBTTimingModeEaseBackOut:
            return ^double(double t){
                return [SBTEasing easeBackOut:t];
            };
            break;
        case SBTTimingModeEaseBackInOut:
            return ^double(double t){
                return [SBTEasing easeBackInOut:t];
            };
            break;
            
            // Ease Bounce
        case SBTTimingModeEaseBounceIn:
            return ^double(double t){
                return [SBTEasing easeBounceIn:t];
            };
            break;
        case SBTTimingModeEaseBounceOut:
            return ^double(double t){
                return [SBTEasing easeBounceOut:t];
            };
            break;
        case SBTTimingModeEaseBounceInOut:
            return ^double(double t){
                return [SBTEasing easeBounceInOut:t];
            };
            break;

            // Ease Elastic
        case SBTTimingModeEaseElasticIn:
            return ^double(double t){
                return [SBTEasing easeElasticIn:t];
            };
            break;
        case SBTTimingModeEaseElasticOut:
            return ^double(double t){
                return [SBTEasing easeElasticOut:t];
            };
            break;
        case SBTTimingModeEaseElasticInOut:
            return ^double(double t){
                return [SBTEasing easeElasticInOut:t];
            };
            break;

        default:
            break;
    }
    
    NSAssert(NO, @"Unknown timing mode type");
    return nil;
}


#pragma mark - Ease Sine

+(double)easeSineIn:(double)t{
    
    double newT = -1*cosf(t * (double)M_PI_2) +1;
    return newT;
}

+(double)easeSineOut:(double)t{
    
    return sinf(t * (double)M_PI_2);
    
}

+(double)easeSineInOut:(double)t{
    
    return sinf(t * (double)M_PI_2);
    
}

#pragma mark - Ease Exponential

+(double)easeExponentialIn:(double)t{
    
    return (t==0) ? 0 : powf(2, 10 * (t/1 - 1)) - 1 * 0.001f;
    
}

+(double)easeExponentialOut:(double)t{
    
    return (t==1) ? 1 : (-powf(2, -10 * t/1) + 1);
    
}

+(double)easeExponentialInOut:(double)t{
    
    t /= 0.5f;
    if (t < 1)
        t = 0.5f * powf(2, 10 * (t - 1));
    else
        t = 0.5f * (-powf(2, -10 * (t -1) ) + 2);
    
    return t;
    
}

#pragma mark - Ease Back

+(double)easeBackIn:(double)t{
    
    double overshoot = 1.70158f;
    return t * t * ((overshoot + 1) * t - overshoot);
}

+(double)easeBackOut:(double)t{
    
    double overshoot = 1.70158f;
    
    t = t - 1;
    return t * t * ((overshoot + 1) * t + overshoot) + 1;
    
}

+(double)easeBackInOut:(double)t{
    
    double overshoot = 1.70158f * 1.525f;
    
    t = t * 2;
    if (t < 1)
        return (t * t * ((overshoot + 1) * t - overshoot)) / 2;
    else {
        t = t - 2;
        return (t * t * ((overshoot + 1) * t + overshoot)) / 2 + 1;
    }
    
}

#pragma mark - Ease Bounce

+(double) bounceTime:(double) t
{
    if (t < 1 / 2.75) {
        return 7.5625f * t * t;
    }
    else if (t < 2 / 2.75) {
        t -= 1.5f / 2.75f;
        return 7.5625f * t * t + 0.75f;
    }
    else if (t < 2.5 / 2.75) {
        t -= 2.25f / 2.75f;
        return 7.5625f * t * t + 0.9375f;
    }
    
    t -= 2.625f / 2.75f;
    return 7.5625f * t * t + 0.984375f;
}

+(double)easeBounceIn:(double)t{
    
    double newT = t;
    if( t !=0 && t!=1)
        newT = 1 - [self bounceTime:1-t];
    
    return newT;
    
}

+(double)easeBounceOut:(double)t{
    
    double newT = t;
    if( t !=0 && t!=1)
        newT = [self bounceTime:t];
    
    return newT;
    
}

+(double)easeBounceInOut:(double)t{
    
    double newT;
    if( t ==0 || t==1)
        newT = t;
    else if (t < 0.5) {
        t = t * 2;
        newT = (1 - [self bounceTime:1-t] ) * 0.5f;
    } else
        newT = [self bounceTime:t * 2 - 1] * 0.5f + 0.5f;
    
    return newT;
    
}

#pragma mark - Ease Elastic

+(double)easeElasticIn:(double)t{
    
    double newT = 0;
    if (t == 0 || t == 1)
        newT = t;
    
    else {
        double s = kPERIOD / 4;
        t = t - 1;
        newT = -powf(2, 10 * t) * sinf( (t-s) *M_PI_X_2 / kPERIOD);
    }
    return newT;
    
}

+(double)easeElasticOut:(double)t{
    
    double newT = 0;
    if (t == 0 || t == 1) {
        newT = t;
        
    } else {
        double s = kPERIOD / 4;
        newT = powf(2, -10 * t) * sinf( (t-s) *M_PI_X_2 / kPERIOD) + 1;
        
    }
    return newT;
}

+(double)easeElasticInOut:(double)t{
    
    double newT = 0;
    
    if( t == 0 || t == 1 )
        newT = t;
    else {
        t = t * 2;
        double s = kPERIOD / 4;
        
        t = t -1;
        if( t < 0 )
            newT = -0.5f * powf(2, 10 * t) * sinf((t - s) * M_PI_X_2 / kPERIOD);
        else
            newT = powf(2, -10 * t) * sinf((t - s) * M_PI_X_2 / kPERIOD) * 0.5f + 1;
    }
    return newT;
    
}

@end
