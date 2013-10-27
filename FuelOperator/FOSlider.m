//
//  FOSlider.m
//  FuelOperator
//
//  Created by Gary Robinson on 10/27/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "FOSlider.h"

@implementation FOSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds
{
    return self.bounds;
}
- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds
{
    return self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
