//
//  SBTVariable.h
//  SBTween
//
//  Created by Steven Barnegren on 16/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SBTVariableTypeDouble,
    SBTVariableTypeVec2,
} SBTVariableType;

struct SBTVec2 {
    double x;
    double y;
};

@interface SBTVariable : NSObject

@property NSString *name;
@property double doubleValue;

-(instancetype)initWithName:(NSString*)name doubleValue:(double)value;

@end
