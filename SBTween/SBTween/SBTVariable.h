//
//  SBTVariable.h
//  SBTween
//
//  Created by Steven Barnegren on 16/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <Foundation/Foundation.h>

//**********************************
#pragma mark - ***** Data Types *****
//**********************************

typedef enum : NSUInteger {
    SBTValueTypeDouble,
    SBTValueTypeVec2,
    SBTValueTypeVec3,
    SBTValueTypeVec4,
} SBTValueType;

NSString* SBTValueTypeToString(SBTValueType type);

typedef struct{
    double x;
    double y;
} SBTVec2;

SBTVec2 SBTVec2Make(double x, double y);

typedef struct{
    double x;
    double y;
    double z;
} SBTVec3;

SBTVec3 SBTVec3Make(double x, double y, double z);

typedef struct{
    double x;
    double y;
    double z;
    double w;
} SBTVec4;

SBTVec4 SBTVec4Make(double x, double y, double z, double w);

//**********************************
#pragma mark - ***** SBTValue *****
//**********************************

@interface SBTValue : NSObject <NSCopying>
@property SBTValueType type;
@property double doubleValue;
@property SBTVec2 vec2Value;
@property SBTVec3 vec3Value;
@property SBTVec4 vec4Value;

+(instancetype)valueWithDouble:(double)doubleValue;
+(instancetype)valueWithVec2:(SBTVec2)vec2Value;
+(instancetype)valueWithVec3:(SBTVec3)vec3Value;
+(instancetype)valueWithVec4:(SBTVec4)vec4Value;

-(instancetype)initWithDoubleValue:(double)doubleValue;
-(instancetype)initWithVec2Value:(SBTVec2)vec2Value;
-(instancetype)initWithVec3Value:(SBTVec3)vec3Value;
-(instancetype)initWithVec4Value:(SBTVec4)vec4Value;

@end

//**********************************
#pragma mark - SBTVariable
//**********************************

@interface SBTVariable : NSObject
@property NSString *name;
@property SBTValue *value;

-(instancetype)initWithName:(NSString*)name doubleValue:(double)doubleValue;
-(instancetype)initWithName:(NSString*)name vec2Value:(SBTVec2)vec2Value;
-(instancetype)initWithName:(NSString*)name vec3Value:(SBTVec3)vec3Value;
-(instancetype)initWithName:(NSString*)name vec4Value:(SBTVec4)vec4Value;

-(SBTValueType)valueType;

@end
