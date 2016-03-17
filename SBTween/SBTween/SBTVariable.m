//
//  SBTVariable.m
//  SBTween
//
//  Created by Steven Barnegren on 16/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTVariable.h"

@implementation SBTVariable

-(instancetype)initWithName:(NSString*)name doubleValue:(double)value{
    if (self = [super init]) {
        self.name = name;
        self.doubleValue = value;
    }
    return self;
}

@end
