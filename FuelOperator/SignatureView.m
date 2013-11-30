//
//  SignatureView.m
//  FuelOperator
//
//  Created by Gary Robinson on 11/30/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "SignatureView.h"

#define MIN_DISTANCE 5.0
#define DEFAULT_WIDTH 5.0

@interface SignatureView ()

@property CGPoint currentPoint;
@property CGPoint previousPoint1;
@property CGPoint previousPoint2;
@property CGMutablePathRef path;

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *label;

@end

@implementation SignatureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.path = CGPathCreateMutable();
        
        [self addSubview:self.line];
        [self addSubview:self.label];
    }
    return self;
}

- (UIView *)line
{
    if(_line == nil)
    {
        _line = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 30, self.frame.size.width - 20, 1)];
        _line.backgroundColor = [UIColor blackColor];
    }
    return _line;
}

- (UILabel *)label
{
    if(_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 25, self.frame.size.width - 20, 25)];
        _label.font = [UIFont regularFontOfSize:16];
        _label.textColor = [UIColor fopDarkText];
        _label.textAlignment = NSTextAlignmentRight;
        _label.text = @"Signature";
    }
    return _label;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    self.previousPoint1 = [touch previousLocationInView:self];
    self.previousPoint2 = [touch previousLocationInView:self];
    self.currentPoint = [touch locationInView:self];
    
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    //check if the point is farther than min dist from previous */
    CGFloat dx = point.x - self.currentPoint.x;
    CGFloat dy = point.y - self.currentPoint.y;
    
    if ((dx * dx + dy * dy) < (MIN_DISTANCE * MIN_DISTANCE))
        return;
    
    self.previousPoint2 = self.previousPoint1;
    self.previousPoint1 = [touch previousLocationInView:self];
    self.currentPoint = [touch locationInView:self];
    
    CGPoint mid1 = midPoint(self.previousPoint1, self.previousPoint2);
    CGPoint mid2 = midPoint(self.currentPoint, self.previousPoint1);
    CGMutablePathRef subpath = CGPathCreateMutable();
    CGPathMoveToPoint(subpath, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(subpath, NULL, self.previousPoint1.x, self.previousPoint1.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(subpath);
    
    CGPathAddPath(self.path, NULL, subpath);
    CGPathRelease(subpath);
    
    CGRect drawBox = bounds;
    drawBox.origin.x -= DEFAULT_WIDTH * 2.0;
    drawBox.origin.y -= DEFAULT_WIDTH * 2.0;
    drawBox.size.width += DEFAULT_WIDTH * 3.0;
    drawBox.size.height += DEFAULT_WIDTH * 3.0;
    
    [self setNeedsDisplayInRect:drawBox];

}

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(context, self.path);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, DEFAULT_WIDTH);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGContextStrokePath(context);
}


@end
