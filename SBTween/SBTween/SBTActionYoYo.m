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
@end

@implementation SBTActionYoYo

-(instancetype)initWithAction:(SBTAction*)action{
    
    NSAssert(action.hasDuration, @"YoYo action must have duration");
    
    if (self = [super init]){
        self.action = action;
    }
    
    return self;
}

-(void)calculateValuesWithVariables:(NSMutableDictionary *)variables{
    [super calculateValuesWithVariables:variables];
    self.duration = self.action.duration * 2;
}

-(void)setContext:(SBTContext *)context{
    [super setContext:context];
    self.action.context = context;
}

@end
