//
//  SBTActionRepeat.h
//  SBTween
//
//  Created by Steven Barnegren on 07/04/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTAction.h"

@interface SBTActionRepeat : SBTAction

-(instancetype)initWithAction:(SBTAction*)action numRepeats:(NSInteger)numRepeats;

@end
