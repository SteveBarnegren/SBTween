//
//  SBTActionSequence.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionSequence.h"
#import "SBTActionInterpolate.h" // <-- REMOVE THIS

@interface SBTActionSequence ()
@property (nonatomic, strong) NSArray<SBTAction*> *allActions;
@property (nonatomic, strong) NSArray<SBTAction*> *startActions;
@property (nonatomic, strong) NSArray<SBTAction*> *updateActions;
@property (nonatomic, strong) NSArray<SBTAction*> *endActions;

@property double lastUpdateTime;
@property (nonatomic, weak) SBTAction *lastRunAction;
@end

@implementation SBTActionSequence

#pragma mark - Creation

-(instancetype)initWithActions:(NSArray<SBTAction*>*)actions{
    
    if (self = [super init]) {
        [self setupActionSequenceWithActions:actions];
    }
    
    return self;
}

-(void)setupActionSequenceWithActions:(NSArray<SBTAction*>*)actions{
    
    self.lastRunAction = nil;
    self.lastUpdateTime = 0;
    self.allActions = actions;
    
    // Separate out the on start call blocks
    {
        NSMutableArray *mutStartActions = [[NSMutableArray alloc]init];
        for (SBTAction *action in actions) {
            if (action.hasDuration) { break; }
            [mutStartActions addObject:action];
        }
        self.startActions = [NSArray arrayWithArray:mutStartActions];
    }
   // Separate the on finish call blocks
    {
        NSMutableArray *mutEndActions = [[NSMutableArray alloc]init];
        for (SBTAction *action in actions.reverseObjectEnumerator) {
            if (action.hasDuration) { break; }
            [mutEndActions addObject:action];
        }
        self.endActions = [NSArray arrayWithArray:mutEndActions];
    }
    // Get the duration actions
    {
        NSMutableArray *mutDurationActions = [[NSMutableArray alloc]init];
        for (SBTAction *action in actions) {
            if (![self.startActions containsObject:action] && ![self.endActions containsObject:action]){
                [mutDurationActions addObject:action];
            }
        }
        self.updateActions = [NSArray arrayWithArray:mutDurationActions];
    }
}

-(void)calculateValuesWithVariables:(NSMutableDictionary*)variables{
    for (SBTAction *action in self.allActions) {
        [action calculateValuesWithVariables:variables];
    }
    
    // Set duration type
    self.durationType = [[self class]durationTypeForActions:self.allActions];
    
    // Work out duration
    if (self.durationType != SBTDurationTypeInfinite) {
        self.duration = 0;
        for (SBTAction *action in self.updateActions) {
            self.duration += action.duration;
        }
    }
   
}

-(void)willBecomeActive{
    [super willBecomeActive];
    for (SBTAction *action in self.reverse ? self.endActions : self.startActions) {
        [action willBecomeActive];
        [action willBecomeInactive];
    }
    
    self.lastRunAction = nil;
}

-(void)actionWillEnd{
    [super willBecomeInactive];
    for (SBTAction *action in self.reverse ? self.startActions : self.endActions) {
        [action willBecomeInactive];
        [action willBecomeActive];
    }
    
    // End the last action in the sequence
    if (self.updateActions) {
        SBTAction *lastUpdateAction = self.reverse ? [self.updateActions firstObject] : [self.updateActions lastObject];
        [lastUpdateAction updateWithTime: self.reverse ? 0 : 1];
        [lastUpdateAction willBecomeInactive];
    }
    
    self.lastRunAction = nil;
    
}

-(void)setContext:(SBTContext *)context{
    [super setContext:context];
    for (SBTAction *action in self.allActions) {
        action.context = context;
    }
}

-(void)setReverse:(BOOL)reverse{
    [super setReverse:reverse];
    for (SBTAction *action in self.allActions) {
        action.reverse = reverse;
    }
}

-(void)setVariablesToEndStates{
    for (SBTAction *action in self.allActions) {
        [action setVariablesToEndStates];
    }
}

#pragma mark - Update

-(void)updateWithTime:(double)t{
    
    //NSLog(@"SEQUENCE t: %f", t);
    
    /* 
     Need to trigger the beginning callblocks in willStart, and the end call blocks on willEnd:
     when actions are passed in, split into three arrays, beginning callblocks, end call blocks, and update actions
     */
    
    //double lastElapsedTime = self.lastUpdateTime * self.duration;
    double elapsedTime = t * self.duration;
   
    // Get actions begin and end times
    double startTimes[self.updateActions.count];
    double endTimes[self.updateActions.count];
    {
        double startPosition = 0;
        NSInteger index = 0;
        for (SBTAction *action in self.updateActions) {
            startTimes[index] = startPosition;
            endTimes[index] = action.hasDuration ? startPosition + action.duration : startPosition;
            startPosition += action.duration;
            index++;
        }
    }
    
    // Update
    BOOL startedActionChain = NO;
    if (!self.lastRunAction) {
        startedActionChain = YES;
    }
    
    NSInteger actionIndex = 0;
    if (self.lastRunAction) {
        actionIndex = [self.updateActions indexOfObject:self.lastRunAction];
    }
    else if (self.reverse){
        actionIndex = self.updateActions.count-1;
    }
    
    while ((self.reverse && actionIndex >= 0) || (!self.reverse && actionIndex < self.updateActions.count)) {
        
        SBTAction *action = self.updateActions[actionIndex];
        
        // Start Action
        if (action != self.lastRunAction) {
            [self.lastRunAction updateWithTime:self.reverse ? 0 : 1];
            [self.lastRunAction willBecomeInactive];
            [action willBecomeActive];
            self.lastRunAction = action;
        }
        
        // Update Action
        double actionStart = startTimes[actionIndex];
        double actionEnd = endTimes[actionIndex];
        
        double actionTime = elapsedTime - actionStart;
        
        if (!self.reverse && actionTime > action.duration) {
            actionTime = action.duration;
        }
        if (self.reverse && actionTime < 0) {
            actionTime = 0;
        }
        [action updateWithElapsedDuration:actionTime];

        // Break
        if ((!self.reverse && elapsedTime < actionEnd) || (self.reverse && elapsedTime > actionStart)) {
            break;
        }
        
        actionIndex += self.reverse ? -1 : 1;
    }
    
    self.lastUpdateTime = t;
}

@end
