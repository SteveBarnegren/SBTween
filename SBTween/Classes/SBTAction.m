//
//  SBTAnimation.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTAction.h"
#import "SBTEasing.h"

@interface SBTAction ()

@end

@implementation SBTAction

#pragma mark - Class Methods
+(SBTDurationType)durationTypeForActions:(NSArray*)actions{
    
    SBTDurationType type = SBTDurationTypeNone;
    
    for (SBTAction *action in actions) {
        
        if (type == SBTDurationTypeNone && action.durationType == SBTDurationTypeFinite) {
            type = SBTDurationTypeFinite;
        }
        if (action.durationType == SBTDurationTypeInfinite){
            type = SBTDurationTypeInfinite;
            break;
        }
    }
    
    return type;
}

#pragma mark - LifeCycle

-(instancetype)init{
    if (self = [super init]) {
        self.durationType = SBTDurationTypeFinite;
        self.reverse = NO;
    }
    return self;
}

-(void)calculateValuesWithVariables:(NSMutableDictionary*)variables{/* BASE */}
-(void)setVariablesToEndStates{/* BASE */}
-(void)actionWasAddedToContext{/* BASE */}
-(void)willBecomeActive{
    if (self.becomeActiveCallback) {
        self.becomeActiveCallback();
    }
}
-(void)willBecomeInactive{
    if (self.becomeInactiveCallback) {
        self.becomeInactiveCallback();
    }
}

#pragma mark - Callbacks

-(void)setBecomeActiveCallback:(void (^)())becomeActiveCallback{
    NSAssert(self.durationType, @"Cannot set active / inactive callbacks on actions without duration");
    _becomeActiveCallback = becomeActiveCallback;
}

-(void)setBecomeInactiveCallback:(void (^)())becomeInactiveCallback{
    NSAssert(self.hasDuration, @"Cannot set active / inactive callbacks on actions without duration");
    _becomeInactiveCallback = becomeInactiveCallback;
}

#pragma mark - Update
-(void)updateWithElapsedDuration:(double)elapsed{
    
    if (self.duration == 0) {
        [self updateWithTime:0];
    }
    else{
        [self updateWithTime:elapsed/self.duration];
    }
}

-(void)updateWithTime:(double)t{/* BASE */}

#pragma mark - Duration

-(BOOL)hasDuration{
    return self.durationType == SBTDurationTypeNone ? NO : YES;
}


@end


