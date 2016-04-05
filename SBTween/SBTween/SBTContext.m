//
//  SBTContext.m
//  SBTween
//
//  Created by Steven Barnegren on 17/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTContext.h"
#import "SBTCommon.h"
@import QuartzCore;

//********************************************************
#pragma mark - ******* SBTScheduledAction ******
//********************************************************

@interface SBTScheduledAction ()
@property double lastUpdateTime;
@property double elapsedTime;
@property (nonatomic) BOOL reverse;
@property BOOL running;
@property (nonatomic, strong) SBTAction *action;
@property (nonatomic, copy) void (^updateBlock)();
@end

@implementation SBTScheduledAction

+(SBTScheduledAction*)scheduledActionWithAction:(SBTAction*)action reverse:(BOOL)reverse updateBlock:(void (^)())updateBlock{
    SBTScheduledAction *scheduledAction = [[SBTScheduledAction alloc]init];
    scheduledAction.action = action;
    scheduledAction.updateBlock = updateBlock;
    scheduledAction.reverse = reverse;
    if (reverse) {
        scheduledAction.elapsedTime = action.duration;
        [action setVariablesToEndStates];
    }
    scheduledAction.action.reverse = reverse;
    scheduledAction.lastUpdateTime = reverse ? kSBTActionTimeJustAfter : kSBTActionTimeJustBefore;
    return scheduledAction;
}

-(void)setReverse:(BOOL)reverse{
    if (reverse != _reverse) {
        _reverse = reverse;
        self.action.reverse = reverse;
    }
}

-(instancetype)init{
    if (self = [super init]){
        self.elapsedTime = 0;
    }
    return self;
}

-(void)updateWithTime:(double)t{
    
    // if the last update wasnt' in range, and neither is this one, discard
    if (!IsUnitInterpolatorInRange(self.lastUpdateTime) && !IsUnitInterpolatorInRange(t)) {
        return;
    }
    
    // Set the correct direction
    if (!self.reverse && t < self.lastUpdateTime) {
        self.reverse = YES;
    }
    if (self.reverse && t > self.lastUpdateTime) {
        self.reverse = NO;
    }
    
    // If update is in range, but the last one wasn't, tell the action it will begin
    if (!IsUnitInterpolatorInRange(self.lastUpdateTime) && IsUnitInterpolatorInRange(t)) {
        [self.action actionWillStart];
    }
    
    // update time
    [self.action updateWithTime:ConstrainUnitInterpolator(t)];
    if (self.updateBlock) {
        self.updateBlock();
    }
    
    // If the last update was in range, but this one isn't, end
    if (IsUnitInterpolatorInRange(self.lastUpdateTime) && !IsUnitInterpolatorInRange(t)) {
        [self.action actionWillEnd];
    }
    
    self.lastUpdateTime = t;
}

@end

//********************************************************
#pragma mark - ******* SBTContext ******
//********************************************************

@interface SBTContext ()
@property (nonatomic, strong) NSMutableDictionary *variables;
@property (nonatomic, strong) NSMutableArray *scheduledActions;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property BOOL hasReferenceFrameTimeStamp;
@property double lastFrameTimeStamp;
@end

@implementation SBTContext

#pragma mark - Setup

-(instancetype)init{
    
    if (self = [super init]) {
        [self setupContext];
    }
    return self;
}

-(void)setupContext{
    
    // Init Properties
    self.variables = [[NSMutableDictionary alloc]init];
    self.scheduledActions = [[NSMutableArray alloc]init];
    
}

#pragma mark - Variables

-(void)addVariable:(SBTVariable*)variable{
    
    NSAssert(variable.name && variable.name.length != 0, @"SBTVariable must have a name when added to context");
    [self.variables setObject:variable forKey:variable.name];
}

-(void)addVariables:(NSArray*)variables{
    for (SBTVariable *variable in variables) {
        [self addVariable:variable];
    }
}

-(SBTVariable*)variableWithName:(NSString*)name{
    
    SBTVariable *variable = self.variables[name];
    if (!variable) {
        NSLog(@"Cannot find variable with name %@. Make sure you add the variable to context first", name);
    }
    return variable;
}

#pragma mark - Run Actions

//-(void)runAction:(SBTAction*)action withupdateBlc{
//    [self addAction:action startRunning:YES];
//}
//
//-(void)addAction:(SBTAction*)action{
//    [self addAction:action startRunning:NO];
//}

/* This method could be private and use the above methods for public */
-(SBTScheduledAction*)addAction:(SBTAction*)action
                        reverse:(BOOL)reverse
                    updateBlock:(void (^)())updateBlock
                   startRunning:(BOOL)startRunning{
    
    action.context = self;
    [action calculateValuesWithVariables:[NSMutableDictionary dictionary]];
    SBTScheduledAction *scheduledAction = [SBTScheduledAction scheduledActionWithAction:action
                                                                                reverse:reverse
                                                                            updateBlock:updateBlock];
    [self.scheduledActions addObject:scheduledAction];
    [action actionWillStart];
    scheduledAction.running = startRunning;
    if (startRunning) {
        [self startRunLoop];
    }
    return scheduledAction;

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
        scheduledAction.elapsedTime += scheduledAction.reverse ? -dt : dt;
        
        if (scheduledAction.elapsedTime >= scheduledAction.action.duration) {
            [scheduledAction updateWithTime:1.0];
            if (!scheduledAction.reverse) {
                [scheduledAction.action actionWillEnd];
                if (scheduledAction.updateBlock) { scheduledAction.updateBlock(); }
                [actionsToRemove addObject:scheduledAction];
            }
        }
        else if (scheduledAction.elapsedTime <= 0) {
            [scheduledAction updateWithTime:0];
            if (scheduledAction.reverse) {
                [scheduledAction.action actionWillEnd];
                if (scheduledAction.updateBlock) { scheduledAction.updateBlock(); }
                [actionsToRemove addObject:scheduledAction];
            }
        }
        else{
            [scheduledAction updateWithTime:scheduledAction.elapsedTime / scheduledAction.action.duration];
        }
    }
    
    for (SBTScheduledAction *scheduledAction in actionsToRemove) {
        [self removeScheduledAction:scheduledAction];
    }
}

@end
