//
//  SBTCommon.m
//  SBTween
//
//  Created by Steven Barnegren on 05/04/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SBTCommon.h"

double ConstrainUnitInterpolator(double t){
    t = MIN(t, 1);
    t = MAX(t, 0);
    return t;
}

BOOL IsUnitInterpolatorInRange(double t){
    
    if (t < 0) { return NO; }
    if (t > 1) { return NO; }
    return YES;
    
}


