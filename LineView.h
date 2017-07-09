//
//  LineView.h
//  2w2d5_fingerPaintApp
//
//  Created by Seantastic31 on 09/07/2017.
//  Copyright © 2017 Seantastic31. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView

@property (strong, nonatomic) UIBezierPath *path;
@property (strong ,nonatomic) UIColor *lineColor;

- (instancetype)initWithLineWidth:(CGFloat)width andColor:(UIColor*)color;

@end
