//
//  SBTActionDelay.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionDelay.h"

@implementation SBTActionDelay

-(instancetype)initWithDelay:(double)delay{
    
    if (self = [super init]) {
        self.duration = delay;
    }
    return self;
}

@end
