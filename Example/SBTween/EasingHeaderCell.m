//
//  EasingHeaderCell.m
//  SBTween
//
//  Created by Steve Barnegren on 14/05/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "EasingHeaderCell.h"

@interface EasingHeaderCell ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation EasingHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setTitle:(NSString*)title{
    self.titleLabel.text = title;
}

@end
