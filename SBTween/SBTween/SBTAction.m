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

-(instancetype)init{
    if (self = [super init]) {
        self.hasDuration = YES;
        self.reverse = NO;
    }
    return self;
}

#pragma mark - LifeCycle
-(void)calculateValuesWithVariables:(NSMutableDictionary*)variables{/* BASE */}
-(void)setVariablesToEndStates{/* BASE */}
-(void)actionWasAddedToContext{/* BASE */}
-(void)actionWillStart{/* BASE */}
-(void)actionWillEnd{/* BASE */}

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

@end
