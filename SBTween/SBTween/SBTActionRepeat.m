//
//  SBTActionRepeat.m
//  SBTween
//
//  Created by Steven Barnegren on 07/04/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionRepeat.h"

@interface SBTActionRepeat ()
@property NSInteger numRepeats;
@property (nonatomic, strong) SBTAction *action;
@property NSInteger lastUpdateRepeatNumber;
@property BOOL hasPerformedFirstUpdate;
@end

@implementation SBTActionRepeat

-(instancetype)initWithAction:(SBTAction*)action numRepeats:(NSInteger)numRepeats{
    
    NSAssert(numRepeats >= 2, @"Number of repeats must be greater than one");
    if (self = [super init]){
        self.numRepeats = numRepeats;
        self.action = action;
    }
    return self;
}

-(void)calculateValuesWithVariables:(NSMutableDictionary *)variables{
    [super calculateValuesWithVariables:variables];
    [self.action calculateValuesWithVariables:variables];
    self.duration = self.action.duration * self.numRepeats;
}

-(void)willBecomeActive{
    [super willBecomeActive];
    [self.action willBecomeActive];
    self.lastUpdateRepeatNumber = self.reverse ? self.numRepeats + 1 : -1;
    self.hasPerformedFirstUpdate = NO;
}

-(void)willBecomeInactive{
    [super willBecomeInactive];
    [self.action willBecomeInactive];
}

-(void)setReverse:(BOOL)reverse{
    [super setReverse:reverse];
    self.action.reverse = reverse;
}

-(void)setContext:(SBTContext *)context{
    [super setContext:context];
    [self.action setContext:context];
}

-(void)updateWithTime:(double)t{
    [super updateWithTime:t];
    
    double actionTime = t * self.duration / self.action.duration;
    NSInteger repeatNumber = (NSInteger)actionTime;
    actionTime = actionTime - repeatNumber;
    
    if (repeatNumber != self.lastUpdateRepeatNumber) {
        if (self.hasPerformedFirstUpdate) {
            [self.action willBecomeInactive];
        }
        [self.action willBecomeActive];
    }
    self.lastUpdateRepeatNumber = repeatNumber;
    
    [self.action updateWithTime:t];
    self.hasPerformedFirstUpdate = YES;
}

@end