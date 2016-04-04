//
//  SBTContext.m
//  SBTween
//
//  Created by Steven Barnegren on 17/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTContext.h"
@import QuartzCore;

//********************************************************
#pragma mark - ******* SBTScheduledAction ******
//********************************************************

@interface SBTScheduledAction : NSObject
@property double elapsedTime;
@property BOOL reverse;
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
-(void)addAction:(SBTAction*)action reverse:(BOOL)reverse updateBlock:(void (^)())updateBlock startRunning:(BOOL)startRunning{
    
    action.context = self;
    [action calculateValuesWithVariables:[NSMutableDictionary dictionary]];
    [action actionWillStart];
    SBTScheduledAction *scheduledAction = [SBTScheduledAction scheduledActionWithAction:action
                                                                                reverse:reverse
                                                                            updateBlock:updateBlock];
    [self.scheduledActions addObject:scheduledAction];
    if (startRunning) {
        [self startRunLoop];
    }

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
            [scheduledAction.action updateWithTime:1.0];
            if (!scheduledAction.reverse) {
                [scheduledAction.action actionWillEnd];
                if (scheduledAction.updateBlock) { scheduledAction.updateBlock(); }
                [actionsToRemove addObject:scheduledAction];
            }
        }
        else if (scheduledAction.elapsedTime <= 0) {
            [scheduledAction.action updateWithTime:0];
            if (scheduledAction.reverse) {
                [scheduledAction.action actionWillEnd];
                if (scheduledAction.updateBlock) { scheduledAction.updateBlock(); }
                [actionsToRemove addObject:scheduledAction];
            }
        }
        else{
            [scheduledAction.action updateWithTime:scheduledAction.elapsedTime / scheduledAction.action.duration];
            if (scheduledAction.updateBlock) { scheduledAction.updateBlock(); }
        }
    }
    
    for (SBTScheduledAction *scheduledAction in actionsToRemove) {
        [self removeScheduledAction:scheduledAction];
    }
}

@end
