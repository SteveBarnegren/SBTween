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
@end

@implementation SBTActionGroup

#pragma mark - Creation

-(instancetype)initWithActions:(NSArray<SBTAction*>*)actions{
    
    if (self = [super init]) {
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

#pragma mark - Update

-(void)updateWithTime:(double)t{
    
    double elapsedTime = t * self.duration;
        
    for (SBTAction *action in self.actions) {
        if (action.duration >= elapsedTime) {
            [action updateWithElapsedDuration:elapsedTime];
        }
    }
    
}


@end
