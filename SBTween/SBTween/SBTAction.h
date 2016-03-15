//
//  SBTAnimation.h
//  SBTween
//
//  Created by Steven Barnegren on 15/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SBTUpdateBlock)(double t);
typedef void (^SBTCompletionBlock)();

@interface SBTAction : NSObject

@property (nonatomic, copy) SBTUpdateBlock updateBlock;
@property (nonatomic, copy) SBTCompletionBlock completionBlock;

@property double duration;

// Update
-(void)updateWithElapsedDuration:(double)elapsed;
-(void)updateWithTime:(double)t;

@end

