//
//  SBTActionSequence.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionSequence.h"

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
    
    // Work out duration
    self.duration = 0;
    for (SBTAction *action in self.updateActions) {
        self.duration += action.duration;
    }

}

-(void)calculateValuesWithVariables:(NSMutableDictionary*)variables{
    for (SBTAction *action in self.allActions) {
        [action calculateValuesWithVariables:variables];
    }
}

-(void)actionWillStart{
    [super actionWillStart];
    for (SBTAction *action in self.startActions) {
        [action actionWillStart];
        [action actionWillEnd];
    }
}

-(void)actionWillEnd{
    [super actionWillEnd];
    for (SBTAction *action in self.endActions) {
        [action actionWillStart];
        [action actionWillEnd];
    }
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
    
    /* 
     Need to trigger the beginning callblocks in willStart, and the end call blocks on willEnd:
     when actions are passed in, split into three arrays, beginning callblocks, end call blocks, and update actions
     */
    
    double lastElapsedTime = self.lastUpdateTime * self.duration;
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
    
    NSInteger actionIndex = self.reverse ? self.updateActions.count-1 : 0;
    for (SBTAction *action in self.reverse? self.updateActions.reverseObjectEnumerator : self.updateActions) {
        
        if (!startedActionChain && action == self.lastRunAction) {
            startedActionChain = YES;
        }
        
        if (!startedActionChain) {
            actionIndex += self.reverse ? -1 : 1;
            continue;
        }
        
        double actionStart = startTimes[actionIndex];
        double actionEnd = endTimes[actionIndex];

        // Skipped action
        if (action != self.lastRunAction
            && actionStart >= lastElapsedTime
            && actionEnd < elapsedTime) {
            
            [action actionWillStart];
            [action actionWillEnd];
        }
        // Current Action
        else if ((!self.reverse && elapsedTime < actionEnd) || (self.reverse && elapsedTime > actionStart)) {
            if (self.lastRunAction != action) {
                [action actionWillStart];
                self.lastRunAction = action;
            }
            [action updateWithElapsedDuration:elapsedTime - actionStart];
            break;
        }

        actionIndex += self.reverse ? -1 : 1;
        //self.reverse ? actionIndex-- : actionIndex++;
        
    }

    /*
    for (SBTAction *action in self.updateActions) {
        
        double actionEnd = actionStart + action.duration;
        
        // Skipped action
        if (action != self.lastRunAction && actionStart > lastElapsedTime && actionEnd < elapsedTime) {
            [action actionWillStart];
            [action actionWillEnd];
        }
        // Current Action
        else if (elapsedTime < actionStart + action.duration) {
            if (self.lastRunAction != action) {
                [action actionWillStart];
                self.lastRunAction = action;
            }
            [action updateWithElapsedDuration:elapsedTime - actionStart];
            break;
        }
        
        actionStart += action.duration;
        index++;
    }
     */
    
    self.lastUpdateTime = t;
}

/*
-(void)updateWithTime:(double)t{
    
    double elapsedTime = t * self.duration;
    double startOffset = 0;
    
    for (SBTAction *action in self.actions) {
        if (elapsedTime < startOffset + action.duration) {
            if (self.lastRunAction != action) {
                [action actionWillStart];
                self.lastRunAction = action;
            }
            [action updateWithElapsedDuration:elapsedTime - startOffset];
            break;
        }
        startOffset += action.duration;
    }
    
}
 */

@end
