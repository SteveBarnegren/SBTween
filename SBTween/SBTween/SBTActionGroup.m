//
//  SBTActionGroup.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionGroup.h"

@interface SBTActionGroup ()
@property (nonatomic, strong) NSArray<SBTAction*> *actions;
@property double lastUpdateTime;
@end

@implementation SBTActionGroup

#pragma mark - Creation

-(instancetype)initWithActions:(NSArray<SBTAction*>*)actions{
    
    if (self = [super init]) {
        self.lastUpdateTime = 0;
        [self setupActionGroupWithActions:actions];
    }
    
    return self;
}

-(void)setupActionGroupWithActions:(NSArray<SBTAction*>*)actions{
    
    self.actions = actions;
    
    // Work out duration
    self.duration = 0;
    for (SBTAction *action in self.actions) {
        if (action.duration > self.duration) {
            self.duration = action.duration;
        }
    }
}

-(void)actionWillStart{
    [super actionWillStart];
    for (SBTAction *action in self.actions) {
        [action actionWillStart];
    }
}

-(void)setContext:(SBTContext *)context{
    [super setContext:context];
    for (SBTAction *action in self.actions) {
        action.context = context;
    }
}

#pragma mark - Update

-(void)updateWithTime:(double)t{
    
    double elapsedTime = t * self.duration;
    double lastElapsedTime = self.lastUpdateTime * self.duration;
    
    for (SBTAction *action in self.actions) {
        if (action.duration >= elapsedTime) {
            [action updateWithElapsedDuration:elapsedTime];
        }
        
        if (lastElapsedTime < action.duration && elapsedTime >= action.duration) {
            [action actionWillEnd];
        }

    }
    
    self.lastUpdateTime = t;
    
}

@end
















