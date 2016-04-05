//
//  SBTContext.h
//  SBTween
//
//  Created by Steven Barnegren on 17/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBTVariable.h"
#import "SBTAction.h"

//********************************************************
#pragma mark - ******* SBTScheduledAction ******
//********************************************************

@interface SBTScheduledAction : NSObject

-(void)updateWithTime:(double)t;

@end

//********************************************************
#pragma mark - ******* SBTContext ******
//********************************************************

@interface SBTContext : NSObject

// Variables
-(void)addVariable:(SBTVariable*)variable;
-(void)addVariables:(NSArray*)variables;
-(SBTVariable*)variableWithName:(NSString*)name;

// Actions
-(SBTScheduledAction*)addAction:(SBTAction*)action
                        reverse:(BOOL)reverse
                    updateBlock:(void (^)())updateBlock
                   startRunning:(BOOL)startRunning;

@end
