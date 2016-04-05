//
//  SBTActionLinePath.m
//  SBTween
//
//  Created by Steven Barnegren on 05/04/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTActionLinePath.h"
#import "SBTVariable.h"

@interface SBTLinePathPoint : NSObject
@property SBTValue *value;
@property double time;
@property (nonatomic, weak) SBTLinePathPoint *nextPoint; // <-- Super fast iteration
@end

@implementation SBTLinePathPoint

-(double)distanceToPoint:(SBTLinePathPoint*)otherPoint{
    NSAssert(self.value && otherPoint.value, @"Points must have underlying values to compare distance");
    return [self.value distanceFromValue:otherPoint.value];
}

-(double)absDistanceToPoint:(SBTLinePathPoint*)otherPoint{
    return fabs([self distanceToPoint:otherPoint]);
}

@end

@interface SBTActionLinePath ()
@property (nonatomic, strong) NSMutableArray<SBTLinePathPoint*> *points;
@end

@implementation SBTActionLinePath

#pragma mark - Creation

-(instancetype)initWithValues:(NSArray<SBTValue*>*)values duration:(double)duration{
    
    if (self = [super init]) {
        
        NSAssert(values.count >= 2, @"Path must contain at least 2 points");
        NSAssert([self doesArrayContainSBTValuesOfSameType:values],
                 @"Array must contain SBTValue objects with same SBTValueType");
        
        // Create line path points
        NSMutableArray *mutablePoints = [[NSMutableArray alloc]init];
        for (SBTValue *value in values) {
            SBTLinePathPoint *pathPoint = [[SBTLinePathPoint alloc]init];
            pathPoint.value = value;
            [mutablePoints addObject:pathPoint];
        }
        
        // Set next point pointers
        NSInteger index = -1;
        for (SBTLinePathPoint *point in self.points) {
            index++;
            
            if (index == 0) {
                continue;
            }
            
            SBTLinePathPoint *previousPoint = self.points[index-1];
            previousPoint.nextPoint = point;
            
            if (index == self.points.count-1) {
                point.nextPoint = nil;
            }
            
        }
    
        self.points = mutablePoints;
        self.duration = duration;
    }
    return self;
    
}

-(void)calculatePointsTimes{
    
    NSAssert(self.points, @"Points array cannot be nil");
    
    double totalDistance = [self lineDistance];
   
    NSInteger index = -1;
    for (SBTLinePathPoint *point in self.points) {
        index++;

        if (index == 0) {
            continue;
        }
        
        SBTLinePathPoint *previousPoint = self.points[index-1];
        double distance = [previousPoint absDistanceToPoint:point];
        double distancePct = distance / totalDistance;
        previousPoint.time = distancePct;
        
        if (index == self.points.count-1) {
            point.time = 1;
        }
        
    }
    
}

-(double)lineDistance{
    
    double distance = 0;
    
    NSInteger index = -1;
    for (SBTLinePathPoint *point in self.points) {
        index++;
        
        if (index == 0) {
            continue;
        }
        
        SBTLinePathPoint *previousPoint = self.points[index-1];
        distance += [previousPoint absDistanceToPoint:point];
    }
    
    return distance;
}

-(void)updateWithTime:(double)t{

    t = constrainUnitInterpolator(t);
    
    SBTLinePathPoint *lastPoint = [self.points lastObject];
    SBTLinePathPoint *point = [self.points firstObject];
    
    while (point.time < t && point != lastPoint) {
        point = point.nextPoint;
    }

    
    
    
    
    
}

#pragma mark - Debug

-(BOOL)doesArrayContainSBTValuesOfSameType:(NSArray*)array{

    if (!array) { return YES; }
    if (array.count == 0) { return YES; }
    
    id firstObject = [array firstObject];
    if (![firstObject isKindOfClass:[SBTValue class]]) {
        return NO;
    }

    SBTValueType targetType = ((SBTValue*)firstObject).type;
    
    for (SBTValue *value in array) {
        
        if (![value isKindOfClass:[SBTValue class]]) {
            return NO;
        }
        
        if (value.type != targetType) {
            return NO;
        }
    }
    
    return YES;
}

@end
