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
    }
    return self;
}

#pragma makr - LifeCycle

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
