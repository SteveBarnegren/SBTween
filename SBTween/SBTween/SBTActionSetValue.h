//
//  SBTActionSetValue.h
//  SBTween
//
//  Created by Steve Barnegren on 07/04/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTAction.h"

@interface SBTActionSetValue : SBTAction

//Creation
- (instancetype)initWithVariableName:(NSString*)variableName doubleValue:(double)value;
- (instancetype)initWithVariableName:(NSString*)variableName vec2Value:(SBTVec2)value;
- (instancetype)initWithVariableName:(NSString*)variableName vec3Value:(SBTVec3)value;
- (instancetype)initWithVariableName:(NSString*)variableName vec4Value:(SBTVec4)value;

@end
