//
//  LineView.m
//  2w2d5_fingerPaintApp
//
//  Created by Seantastic31 on 09/07/2017.
//  Copyright © 2017 Seantastic31. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (instancetype)initWithLineWidth:(CGFloat)width andColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        _path = [[UIBezierPath alloc]init];
        _path.lineWidth = width;
        _lineColor = color;
    }
    return self;
}

@end
