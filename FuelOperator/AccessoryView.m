//
//  AccessoryView.m
//  FuelOperator
//
//  Created by Gary Robinson on 4/6/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "AccessoryView.h"

@implementation AccessoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor fopRegularText].CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0);
    
    CGContextMoveToPoint(context, 0,0); //start at this point
    
    CGContextAddLineToPoint(context, 5, 5); //draw to this point

    CGContextAddLineToPoint(context, 0, 10); //draw to this point

    // and now draw the Path!
    CGContextStrokePath(context);
}


@end
