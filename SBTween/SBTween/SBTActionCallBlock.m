//
//  SBTActionCallBlock.m
//  SBTween
//
//  Created by Steven Barnegren on 17/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionCallBlock.h"

@interface SBTActionCallBlock ()
@property (nonatomic, copy) void (^block)();
@end

@implementation SBTActionCallBlock

-(instancetype)initWithBlock:(void (^)())block{
    if (self = [super init]) {
        self.block = block;
        self.hasDuration = NO;
    }
    return self;
}

-(void)actionWillStart{
    [super actionWillStart];
    if (self.block) {
        self.block();
    }
}





@end
