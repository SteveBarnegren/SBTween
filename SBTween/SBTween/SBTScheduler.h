//
//  SBTScheduler.h
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBTAction.h"

@interface SBTScheduler : NSObject

#pragma mark - Creation

+(id)sharedScheduler;

-(void)runAction:(SBTAction*)action;

@end
