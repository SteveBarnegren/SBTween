//
//  SBTActionRepeatForever.m
//  Pods
//
//  Created by Steve Barnegren on 16/05/2016.
//
//

#import "SBTActionRepeatForever.h"

@interface SBTActionRepeatForever ()
@property (nonatomic, strong) SBTAction *action;
@property NSInteger lastUpdateRepeatNumber;
@property BOOL hasPerformedFirstUpdate;
@end

@implementation SBTActionRepeatForever

- (instancetype)initWithAction:(SBTAction*)action
{
    
    NSAssert(action.durationType != SBTDurationTypeNone, @"Repeat forever action must have a duration");
    NSAssert(action.durationType != SBTDurationTypeInfinite, @"Repeat forever action cannot have infinite duration");
    
    self = [super init];
    if (self) {
        self.durationType = SBTDurationTypeInfinite;
        self.action = action;
        self.lastUpdateRepeatNumber = -1;
        self.hasPerformedFirstUpdate = NO;
        self.duration = -1;
    }
    return self;
}

-(void)calculateValuesWithVariables:(NSMutableDictionary *)variables{
    
    [self.action calculateValuesWithVariables:variables];
}

-(void)willBecomeActive{
    [super willBecomeActive];
}

-(void)willBecomeInactive{
    [super willBecomeInactive];
}

-(void)setReverse:(BOOL)reverse{
    [super setReverse:reverse];
    self.action.reverse = reverse;
}

-(void)setContext:(SBTContext *)context{
    [super setContext:context];
    [self.action setContext:context];
}

-(void)updateWithElapsedDuration:(double)elapsed{
    [super updateWithElapsedDuration:elapsed];
    
    double actionT = elapsed / self.action.duration;
    NSInteger repeatNumber = actionT;
    
    NSLog(@"repeat number: %@", @(repeatNumber));
    
    if (repeatNumber != self.lastUpdateRepeatNumber) {
        if (self.hasPerformedFirstUpdate) {
            [self.action willBecomeInactive];
        }
        [self.action willBecomeActive];
    }
    self.lastUpdateRepeatNumber = repeatNumber;
    
    [self.action updateWithTime:actionT - repeatNumber];
    self.hasPerformedFirstUpdate = YES;
}

@end