//
//  SBTActionSequence.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionSequence.h"

@interface SBTActionSequence ()
@property (nonatomic, strong) NSArray<SBTAction*> *actions;
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
    
    self.actions = actions;
    self.lastRunAction = nil;
    
    // Work out duration
    self.duration = 0;
    for (SBTAction *action in self.actions) {
        self.duration += action.duration;
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

@end
