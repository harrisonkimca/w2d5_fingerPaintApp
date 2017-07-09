//
//  PaintView.m
//  2w2d5_fingerPaintApp
//
//  Created by Seantastic31 on 09/07/2017.
//  Copyright © 2017 Seantastic31. All rights reserved.
//

#import "PaintView.h"
#import "LineView.h"

@interface PaintView()

@property (strong, nonatomic) NSMutableArray *lines;

@end

@implementation PaintView

{
    // maintain in memory (offscreen) bitmap image to allow app to keep up with touches
    UIImage *incrementalImage;
    // bezier path object
    LineView *path;
    // create array to track four points of Bezier segment and first control point of the next segment
    CGPoint points[5];
    // a counter variable to keep track of the point index
    int index;
}

// initWithCoder (from Storyboard) to create LineView instance (ie, UIBezierPath object holding color/width properties)
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // only allow one finger touch to work at each time
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        // create bezier path object (part of UIKit)
        path = [[LineView alloc]initWithLineWidth:2 andColor:path.lineColor];
    }
    return self;
}

// doing custom drawing so override drawRect by stroking path for every new line segment created
- (void)drawRect:(CGRect)rect
{
    // draw contents of memory buffer first (exact same size) to create illusion of continuous drawing
    [incrementalImage drawInRect:rect];
    // color is property of 'drawing context' vs line width which is property of the path
    [path.lineColor setStroke];
    // stroke path for each new line segment
    [path.path stroke];
}

// ********** UIBezierPath AUTOMATICALLY SETS CURRENT POINT (ie, first point) so need touchesBegan TO SET **********
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // set index to 0 for touch location as starting point for line segment
    index = 0;
    // take touch events
    UITouch *touch = [touches anyObject];
    // use array to add location of touch points
    points[0] = [touch locationInView:self];
    // set style of line (ie, round ends)
    path.path.lineCapStyle = kCGLineCapRound;
}

// touchesMoved can now add new points (which will automatically update to currentpoint) to append line segments (can also add curves in here)
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // take touch events
    UITouch *touch = [touches anyObject];
    // find location of NEW point
    CGPoint point = [touch locationInView:self];
    
    // increment index to move to the next point (ie, index 0 is currentPoint and index 1 is ending point)
    index ++;
    // add new point location to the points array (at index 1)
    points[index] = point;
    
    if (index == 4)
    {
        // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment (ie, make sure the two control points are colinear)
        points[3] = CGPointMake((points[2].x + points[4].x)/2, (points[2].y + points[4].y)/2);
        
        [path.path moveToPoint:points[0]];
        // add a cubic Bezier from points[0] to points[3] with control points points[1] and points[2]
        [path.path addCurveToPoint:points[3] controlPoint1:points[1] controlPoint2:points[2]];
        
        [self setNeedsDisplay];
        
        // replace points and get ready for next segment
        points[0] = points[3];
        points[1] = points[4];
        index = 1;
    }
}

// draw contents of screen into buffer everytime finger is lifted
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self drawBitmap];
    [self setNeedsDisplay];
    // caching allows removal of previous contents and allows string from becoming too long
    [path.path removeAllPoints];
    index = 0;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

// create bitmap context (needs to be created and destroyed explicitly with contents stored in memory)
- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    //first time paint background white
    if (!incrementalImage)
    {
        // enclosing bitmap by a rectangle defined by another UIBezierPath object
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor]setFill];
        // filling it with white
        [rectpath fill];
    }
    [incrementalImage drawAtPoint:CGPointZero];
    [path.lineColor setStroke];
    [path.path stroke];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)changeLineColor:(UIColor*)color
{
    path.lineColor = color;
}

- (void)changeLineWidth:(CGFloat)width
{
    path.path.lineWidth = width;
}

- (void)clearScreen
{
    path = nil; //set current path to nil
    path = [[LineView alloc]initWithLineWidth:2 andColor:path.lineColor];
    incrementalImage = nil;
    
    [self setNeedsDisplay];
}

@end
