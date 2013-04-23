//
//  InnerShadowView.m
//  FuelOperator
//
//  Created by Gary Robinson on 4/12/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "InnerShadowView.h"

@implementation InnerShadowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //self.shadowRadius = 5.0;
        
        UIImage *shadowImage = [UIImage imageNamed:@"innerShadow"];
        
        shadowImage = [shadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        
        UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:shadowImage];
        shadowImageView.contentMode = UIViewContentModeScaleToFill;
        shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        shadowImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:shadowImageView];
    }
    return self;
}

@end
