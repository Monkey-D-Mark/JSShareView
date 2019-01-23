//
//  MFShareButton.m
//  HKTouTiao
//
//  Created by ywch_mxw on 2018/12/20.
//  Copyright © 2018年 东方网. All rights reserved.
//

#import "MFShareButton.h"

static CGFloat imageWidth = 36;
static CGFloat margin = 7;

@implementation MFShareButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return  self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = margin*1.5;
    CGFloat y = 0;
    CGFloat width = imageWidth;
    CGFloat height = width;
    return CGRectMake(x, y, width, height);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x = 0;
    CGFloat y = imageWidth + 8;
    CGFloat width = imageWidth + margin * 3;
    CGFloat height = 17;
    return CGRectMake(x, y, width, height);
}

@end
