//
//  SBTScheduler.m
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTScheduler.h"
@import QuartzCore;

//********************************************************
#pragma mark - ******* SBTScheduledAction ******
//********************************************************

@interface SBTScheduledAction : NSObject
@property double elapsedTime;
@property (nonatomic, strong) SBTAction *action;
@end

@implementation SBTScheduledAction

+(SBTScheduledAction*)scheduledActionWithAction:(SBTAction*)action{
    SBTScheduledAction *scheduledAction = [[SBTScheduledAction alloc]init];
    scheduledAction.action = action;
    return scheduledAction;
}

-(instancetype)init{
    if (self = [super init]){
        self.elapsedTime = 0;
    }
    return self;
}

@end

//********************************************************
#pragma mark - ******* SBTScheduler ******
//********************************************************

@interface SBTScheduler ()
@property (nonatomic, strong) NSMutableArray<SBTScheduledAction*> *scheduledActions;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property BOOL hasReferenceFrameTimeStamp;
@property double lastFrameTimeStamp;
@end

@implementation SBTScheduler

#pragma mark - Creation

+(id)sharedScheduler {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    
    if (self = [super init]) {
        self.scheduledActions = [[NSMutableArray alloc]init];
    }
    return self;
    
}

-(void)runAction:(SBTAction*)action{
  
    SBTScheduledAction *scheduledAction = [SBTScheduledAction scheduledActionWithAction:action];
    [self.scheduledActions addObject:scheduledAction];
    [self startRunLoop];
}

-(void)removeScheduledAction:(SBTScheduledAction*)action{
    
    if (![self.scheduledActions containsObject:action]) {
        NSLog(@"%@ cannot remove an action that is not currently running!", NSStringFromClass([self class]));
        return;
    }
    
    [self.scheduledActions removeObject:action];
    
    if (self.scheduledActions.count == 0) {
        [self stopRunLoop];
    }
}

#pragma mark - Run Loop

-(void)startRunLoop{
    
    if (!self.displayLink) {
        self.hasReferenceFrameTimeStamp = NO;
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

-(void)stopRunLoop{
    
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

-(void)tick {
    
    if (!self.hasReferenceFrameTimeStamp) {
        self.lastFrameTimeStamp = [self.displayLink timestamp];
        self.hasReferenceFrameTimeStamp = YES;
        return;
    }
    
    double currentTime = [self.displayLink timestamp];
    double dt = currentTime - self.lastFrameTimeStamp;
    self.lastFrameTimeStamp = currentTime;
    
    NSMutableArray *actionsToRemove = [[NSMutableArray alloc]init];
    
    for (SBTScheduledAction *scheduledAction in self.scheduledActions) {
        scheduledAction.elapsedTime += dt;
        if (scheduledAction.elapsedTime > scheduledAction.action.duration) {
            [scheduledAction.action updateWithTime:1.0];
            [actionsToRemove addObject:scheduledAction];
        }
        else{
            [scheduledAction.action updateWithTime:scheduledAction.elapsedTime / scheduledAction.action.duration];
        }
    }
    
    for (SBTScheduledAction *scheduledAction in actionsToRemove) {
        [self removeScheduledAction:scheduledAction];
    }
}

@end













