//
//  SBTActionSetValue.m
//  SBTween
//
//  Created by Steve Barnegren on 07/04/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionSetValue.h"
#import "SBTVariable.h"
#import "SBTContext.h"

@interface SBTActionSetValue ()

@property (nonatomic, strong) NSString *variableName;
@property (nonatomic, strong) SBTValue *value;

@end

@implementation SBTActionSetValue

#pragma mark - Creation

-(instancetype)init{
    if (self = [super init]) {
        self.hasDuration = NO;
    }
    return self;
}

- (instancetype)initWithVariableName:(NSString*)variableName doubleValue:(double)value{
    
    self = [self init];
    if (self) {
        self.variableName = variableName;
        self.value = [SBTValue valueWithDouble:value];
    }
    return self;
}

- (instancetype)initWithVariableName:(NSString*)variableName vec2Value:(SBTVec2)value{
    
    self = [self init];
    if (self) {
        self.variableName = variableName;
        self.value = [SBTValue valueWithVec2:value];
    }
    return self;
}

- (instancetype)initWithVariableName:(NSString*)variableName vec3Value:(SBTVec3)value{
    
    self = [self init];
    if (self) {
        self.variableName = variableName;
        self.value = [SBTValue valueWithVec3:value];
    }
    return self;
}

- (instancetype)initWithVariableName:(NSString*)variableName vec4Value:(SBTVec4)value{
    
    self = [self init];
    if (self) {
        self.variableName = variableName;
        self.value = [SBTValue valueWithVec4:value];
    }
    return self;
}

#pragma mark - LifeCycle

-(void)calculateValuesWithVariables:(NSMutableDictionary *)variables{
    
    SBTVariable *variable = variables[self.variableName];
    
    if (!variable) {
        SBTVariable *contextVariable = [self.context variableWithName:self.variableName];
        NSAssert(contextVariable, @"Action references varibale not added to context");
        variable = [contextVariable copy];
        variables[self.variableName] = variable;
    }
    
    variable.value = [self.value copy];
    
}

-(void)willBecomeActive{
    [super willBecomeActive];
    SBTVariable *variable = [self.context variableWithName:self.variableName];
    
    switch (self.value.type) {
        case SBTValueTypeDouble: variable.value.doubleValue = self.value.doubleValue; break;
        case SBTValueTypeVec2: variable.value.vec2Value = self.value.vec2Value; break;
        case SBTValueTypeVec3: variable.value.vec3Value = self.value.vec3Value; break;
        case SBTValueTypeVec4: variable.value.vec4Value = self.value.vec4Value; break;
        default:
            break;
    }
    
}


@end
