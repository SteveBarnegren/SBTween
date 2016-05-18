//
//  SBTAnimation.h
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBTVariable.h"
@class SBTContext;

typedef enum : NSUInteger {
    SBTDurationTypeNone,
    SBTDurationTypeFinite,
    SBTDurationTypeInfinite,
} SBTDurationType;

typedef void (^SBTUpdateBlock)(double t);
typedef void (^SBTCompletionBlock)();

@interface SBTAction : NSObject

@property (nonatomic, weak) SBTContext *context;
@property (nonatomic, copy) SBTUpdateBlock updateBlock;
@property (nonatomic, copy) void (^becomeActiveCallback)();
@property (nonatomic, copy) void (^becomeInactiveCallback)();

@property SBTDurationType durationType;
@property double duration;
@property BOOL reverse;
@property (nonatomic, strong) NSArray<SBTVariable*> *variables;

//Class Methods
+(SBTDurationType)durationTypeForActions:(NSArray*)actions;

// LifeCycle
-(void)calculateValuesWithVariables:(NSMutableDictionary*)variables;
-(void)setVariablesToEndStates;
-(void)actionWasAddedToContext;
-(void)willBecomeActive;
-(void)willBecomeInactive;

// Update
-(void)updateWithElapsedDuration:(double)elapsed;
-(void)updateWithTime:(double)t;

// Duration
-(BOOL)hasDuration;

@end


