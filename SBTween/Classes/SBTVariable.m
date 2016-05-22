//
//  SBTVariable.m
//  SBTween
//
//  Created by Steven Barnegren on 16/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTVariable.h"

//**********************************
#pragma mark - ***** Data Types *****
//**********************************

NSString* SBTValueTypeToString(SBTValueType type){
    
    NSString *string;
    switch (type) {
        case SBTValueTypeDouble: string = @"Double"; break;
        case SBTValueTypeVec2: string = @"Vec2"; break;
        case SBTValueTypeVec3: string = @"Vec3"; break;
        case SBTValueTypeVec4: string = @"Vec4"; break;
        default:
            break;
    }
    
    NSCAssert(string, @"Unknown value type");
    return string;
}

SBTVec2 SBTVec2Make(double x, double y){
    SBTVec2 vec2;
    vec2.x = x;
    vec2.y = y;
    return vec2;
}

SBTVec3 SBTVec3Make(double x, double y, double z){
    SBTVec3 vec3;
    vec3.x = x;
    vec3.y = y;
    vec3.z = z;
    return vec3;
}

SBTVec4 SBTVec4Make(double x, double y, double z, double w){
    SBTVec4 vec4;
    vec4.x = x;
    vec4.y = y;
    vec4.z = z;
    vec4.w = w;
    return vec4;
}

double SBTVec2Distance(SBTVec2 p1, SBTVec2 p2){
    
    double xDiff = p2.x - p1.x;
    double yDiff = p2.y - p1.x;
    
    return sqrt((xDiff * xDiff) + (yDiff * yDiff));
}

double SBTVec2DistanceAbs(SBTVec2 p1, SBTVec2 p2){
    return fabs(SBTVec2Distance(p1, p2));
}

//**********************************
#pragma mark - ***** SBTValue *****
//**********************************

@implementation SBTValue

+(instancetype)valueWithDouble:(double)doubleValue{
    return [[SBTValue alloc]initWithDoubleValue:doubleValue];
}
+(instancetype)valueWithVec2:(SBTVec2)vec2Value{
    return [[SBTValue alloc]initWithVec2Value:vec2Value];
}

+(instancetype)valueWithVec3:(SBTVec3)vec3Value{
    return [[SBTValue alloc]initWithVec3Value:vec3Value];
}
+(instancetype)valueWithVec4:(SBTVec4)vec4Value{
    return [[SBTValue alloc]initWithVec4Value:vec4Value];
}

-(instancetype)initWithDoubleValue:(double)doubleValue{
    if (self = [super init]) {
        _doubleValue = doubleValue;
        _type = SBTValueTypeDouble;
    }
    return self;
}
-(instancetype)initWithVec2Value:(SBTVec2)vec2Value{
    if (self = [super init]) {
        _vec2Value = vec2Value;
        _type = SBTValueTypeVec2;
    }
    return self;
}
-(instancetype)initWithVec3Value:(SBTVec3)vec3Value{
    if (self = [super init]) {
        _vec3Value = vec3Value;
        _type = SBTValueTypeVec3;
    }
    return self;
}
-(instancetype)initWithVec4Value:(SBTVec4)vec4Value{
    if (self = [super init]) {
        _vec4Value = vec4Value;
        _type = SBTValueTypeVec4;
    }
    return self;
}

-(double)distanceFromValue:(SBTValue*)otherValue{
    
    NSAssert(self.type == otherValue.type, @"SBTValues must have same type to compare distance");
    
    double distance = 0;
    
    switch (self.type) {
        case SBTValueTypeDouble:
            NSAssert(NO, @"Double distance not yet implemented");
            break;
        case SBTValueTypeVec2:
            distance = SBTVec2Distance(self.vec2Value, otherValue.vec2Value);
            break;
        case SBTValueTypeVec3:
            NSAssert(NO, @"Vec3 distance not yet implemented");
            break;
        case SBTValueTypeVec4:
            NSAssert(NO, @"Vec4 distance not yet implemented");
            break;
        default:
            NSAssert(NO, @"Unknown type");
            break;
    }
    
    return distance;
}

-(double)absDistanceFromValue:(SBTValue*)otherValue{
    return fabs([self distanceFromValue:otherValue]);
}

-(id)copyWithZone:(NSZone *)zone{
    SBTValue *value = [[SBTValue alloc]init];
    value.type = self.type;
    value.doubleValue = self.doubleValue;
    value.vec2Value = self.vec2Value;
    value.vec3Value = self.vec3Value;
    value.vec4Value = self.vec4Value;
    return value;
}

@end

//**********************************
#pragma mark - ***** NSValue (SBTValue) *****
//**********************************

@implementation NSValue (SBTValue)

+(NSValue*)valueWithSBTVec2:(SBTVec2)vec2{
    
    NSValue *pointValue = [NSValue value:&vec2 withObjCType:@encode(SBTVec2)];
    return pointValue;
}

-(SBTVec2)sbtVec2Value{
    SBTVec2 vec2;
    [self getValue:&vec2];
    return vec2;
}

@end

//**********************************
#pragma mark - SBTVariable
//**********************************

@implementation SBTVariable

-(instancetype)initWithName:(NSString*)name doubleValue:(double)doubleValue{
    if (self = [super init]) {
        self.name = name;
        self.value = [SBTValue valueWithDouble:doubleValue];
    }
    return self;
}

-(instancetype)initWithName:(NSString*)name vec2Value:(SBTVec2)vec2Value{
    if (self = [super init]) {
        self.name = name;
        self.value = [SBTValue valueWithVec2:vec2Value];
    }
    return self;
}

-(instancetype)initWithName:(NSString*)name vec3Value:(SBTVec3)vec3Value{
    if (self = [super init]) {
        self.name = name;
        self.value = [SBTValue valueWithVec3:vec3Value];
    }
    return self;
}

-(instancetype)initWithName:(NSString*)name vec4Value:(SBTVec4)vec4Value{
    if (self = [super init]) {
        self.name = name;
        self.value = [SBTValue valueWithVec4:vec4Value];
    }
    return self;
}

-(SBTValueType)valueType{
    return self.value.type;
}

-(id)copyWithZone:(NSZone *)zone{
    
    SBTVariable *variable = [[SBTVariable alloc]init];
    variable.name = self.name;
    variable.value = self.value;
    return variable;
}


@end
