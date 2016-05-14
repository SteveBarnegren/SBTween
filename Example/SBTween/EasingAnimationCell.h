//
//  EasingAnimationCell.h
//  SBTween
//
//  Created by Steve Barnegren on 11/05/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTween.h"


@interface EasingAnimationCell : UITableViewCell

@property (nonatomic) SBTTimingMode timingMode;

-(void)updateWithTime:(CFTimeInterval)t;

@end
