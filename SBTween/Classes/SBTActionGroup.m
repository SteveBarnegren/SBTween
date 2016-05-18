//
//  SBTActionGroup.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionGroup.h"

@interface SBTActionGroup ()
@property (nonatomic, strong) NSMutableArray<SBTAction*> *allActions;
@property (nonatomic, strong) NSMutableArray<SBTAction*> *startActions;
@property (nonatomic, strong) NSMutableArray<SBTAction*> *endActions;
@property double lastUpdateTime;
@end

@implementation SBTActionGroup

#pragma mark - Creation

-(instancetype)init{
    if (self = [super init]) {
        self.startActions = [[NSMutableArray alloc]init];
        self.endActions = [[NSMutableArray alloc]init];
        self.allActions = [[NSMutableArray alloc]init];
        self.lastUpdateTime = 0;
    }
    return self;
}


-(instancetype)initWithActions:(NSArray<SBTAction*>*)actions{
    
    if (self = [self init]) {
        [self.startActions addObjectsFromArray:actions];
        [self.allActions addObjectsFromArray:actions];
    }
    
    return self;
}

-(void)addAction:(SBTAction*)action atEnd:(BOOL)fromEnd{
    
    if (!fromEnd) {
        [self.startActions addObject:action];
    }
    else{
        [self.endActions addObject:action];
    }
    
    [self.allActions addObject:action];
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
        
        for (SBTAction *action in self.allActions) {
            if (action.duration > self.duration) {
                self.duration = action.duration;
            }
        }

    }
}

-(void)willBecomeActive{
    [super willBecomeActive];
    for (SBTAction *action in self.startActions) {
        [action willBecomeActive];
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
    
    double elapsedTime = t * self.duration;
    double lastElapsedTime = self.lastUpdateTime * self.duration;
    
    for (SBTAction *action in self.startActions) {
        
        if (action.duration < lastElapsedTime && action.duration >= elapsedTime) {
            [action willBecomeActive];
        }
        
        if (action.duration >= elapsedTime) {
            [action updateWithElapsedDuration:elapsedTime];
        }
        
        if (action.duration < elapsedTime && action.duration >= lastElapsedTime) {
            [action willBecomeInactive];
        }
    }
    
    for (SBTAction *action in self.endActions) {
        
        double actionStart = self.duration - action.duration;
        
        if (actionStart > lastElapsedTime && actionStart <= elapsedTime) {
            [action willBecomeActive];
        }
        
        if (actionStart <= elapsedTime) {
            [action updateWithElapsedDuration:elapsedTime - actionStart];
        }
        
        if (actionStart > elapsedTime && actionStart <= lastElapsedTime) {
            [action willBecomeInactive];
        }
    }

    self.lastUpdateTime = t;
    
}

@end




