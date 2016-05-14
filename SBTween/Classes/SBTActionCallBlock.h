//
//  SBTActionCallBlock.h
//  SBTween
//
//  Created by Steven Barnegren on 17/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTAction.h"

@interface SBTActionCallBlock : SBTAction

-(instancetype)initWithBlock:(void (^)(BOOL isReverse))block;

@end
