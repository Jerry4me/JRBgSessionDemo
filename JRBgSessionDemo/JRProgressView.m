//
//  JRProgressView.m
//  JRBgSessionDemo
//
//  Created by sky on 2017/3/24.
//  Copyright © 2017年 sky. All rights reserved.
//

#import "JRProgressView.h"

@implementation JRProgressView

- (void)setProgress:(double)progress
{
    _progress = progress;
    
    CGRect frame = self.frame;
    frame.size.width = JRProgressViewWidth * progress;
    
    self.frame = frame;
    
}

@end
