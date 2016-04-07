//
//  SBTActionYoYo.m
//  SBTween
//
//  Created by Steven Barnegren on 07/04/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionYoYo.h"

@interface SBTActionYoYo ()
@property (nonatomic, strong) SBTAction *action;
@property BOOL isSecondHalf;

@end

@implementation SBTActionYoYo

-(instancetype)initWithAction:(SBTAction*)action{
    
    NSAssert(action.hasDuration, @"YoYo action must have duration");
    
    if (self = [super init]){
        self.action = action;
        self.isSecondHalf = NO;
    }
    
    return self;
}


-(void)calculateValuesWithVariables:(NSMutableDictionary *)variables{
    [super calculateValuesWithVariables:variables];
    [self.action calculateValuesWithVariables:variables];
    self.duration = self.action.duration * 2;
}

-(void)setContext:(SBTContext *)context{
    [super setContext:context];
    self.action.context = context;
}

-(void)willBecomeActive{
    [super willBecomeActive];
    [self.action willBecomeActive];
    self.isSecondHalf = YES;
}

-(void)willBecomeInactive{
    [super willBecomeInactive];
    [self.action willBecomeInactive];
}

-(void)updateWithTime:(double)t{
    [super updateWithTime:t];
    
    double actionT;
    
    if (t < 0.5) {
        if (self.isSecondHalf) {
            self.isSecondHalf = NO;
            [self.action willBecomeInactive];
            self.action.reverse = NO;
            [self.action willBecomeActive];
        }
        actionT = t * 2;
    }
    else{
        if (!self.isSecondHalf) {
            self.isSecondHalf = YES;
            [self.action willBecomeInactive];
            self.action.reverse = YES;
            [self.action willBecomeActive];
        }

        actionT = 1-((t - 0.5) * 2);
    }
    
    [self.action updateWithTime:actionT];
}

@end
