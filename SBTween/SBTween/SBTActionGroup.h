//
//  SBTActionGroup.h
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTAction.h"

@interface SBTActionGroup : SBTAction

// Creation
-(instancetype)initWithActions:(NSArray<SBTAction*>*)actions;

-(void)addAction:(SBTAction*)action atEnd:(BOOL)fromEnd;

@end
