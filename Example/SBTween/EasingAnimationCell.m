//
//  EasingAnimationCell.m
//  SBTween
//
//  Created by Steve Barnegren on 11/05/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "EasingAnimationCell.h"



@interface EasingAnimationCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) CALayer *handle;

@property (nonatomic, copy) SBTTimingFunction timingFunction;

@property float interpolationAmount;

@end

@implementation EasingAnimationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.timingMode = SBTTimingModeLinear;
    self.interpolationAmount = 0;
    
    // Circle layer
    self.handle = [[CALayer alloc]init];
    self.handle.backgroundColor = [UIColor blueColor].CGColor;
    [self.contentView.layer addSublayer:self.handle];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self positionHandle];
}

-(void)setTimingMode:(SBTTimingMode)timingMode{
    _timingMode = timingMode;
    self.timingFunction = [SBTEasing timingFunctionWithMode:timingMode];
}

-(void)updateWithTime:(CFTimeInterval)t{
    
    self.interpolationAmount = t;// = self.timingFunction(t);
    [self positionHandle];
}

-(void)positionHandle{
    
    float titleBottom = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    float handleTop = titleBottom + 8;
    float handleBottom = self.frame.size.height - 8;
    
    float handleSize = (handleBottom - handleTop);
    
    float mostLeftX = 8;
    float mostRightX = self.contentView.bounds.size.width - handleSize - 8;
    
    self.handle.frame = CGRectMake(mostLeftX + ((mostRightX - mostLeftX) * self.interpolationAmount),
                                        handleTop,
                                        handleSize,
                                        handleSize);
}

@end
