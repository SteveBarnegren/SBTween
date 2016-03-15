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
    
    // Work out duration
    self.duration = 0;
    for (SBTAction *action in self.actions) {
        self.duration += action.duration;
    }

}

#pragma mark - Update

-(void)updateWithTime:(double)t{
    
    double elapsedTime = t * self.duration;
    double startOffset = 0;
    
    for (SBTAction *action in self.actions) {
        if (elapsedTime < startOffset + action.duration) {
            [action updateWithElapsedDuration:elapsedTime - startOffset];
            break;
        }
        startOffset += action.duration;
    }
    
}

@end
