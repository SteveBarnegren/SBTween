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

@interface SBTContext : NSObject

// Variables
-(void)addVariable:(SBTVariable*)variable;
-(void)addVariables:(NSArray*)variables;
-(SBTVariable*)variableWithName:(NSString*)name;

// Actions
-(void)addAction:(SBTAction*)action updateBlock:(void (^)())updateBlock startRunning:(BOOL)startRunning;

@end
