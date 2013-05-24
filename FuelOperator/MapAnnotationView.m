//
//  MapAnnotationView.m
//  FuelOperator
//
//  Created by Gary Robinson on 4/27/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "MapAnnotationView.h"

@interface MapAnnotationView ()

@property (nonatomic, strong) UIView *customView;

@end

@implementation MapAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    if(selected)
//        [self addSubview:self.customView];
//    else
//        [self.customView removeFromSuperview];
//}
//

- (UIView *)customView
{
    if(_customView == nil)
    {
        _customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAP_ANNOTATION_VIEW_WIDTH, MAP_ANNOTATION_VIEW_HEIGHT)];
        _customView.layer.cornerRadius = 5.0;
        _customView.backgroundColor = [UIColor clearColor];
        
//        UIImageView *test = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon"]];
//        [_customView addSubview:test];
    }
    return _customView;
}

- (void)didAddSubview:(UIView *)subview
{
    if([[[subview class] description] isEqualToString:@"UICalloutView"])
    {
        int image = 0;
        for(UIView *subsubView in subview.subviews)
        {
            if([subsubView class] == [UIImageView class])
            {
                UIImageView *imageView = ((UIImageView *)subsubView);
//                CGRect rect = imageView.frame;
//                rect.size.width *= 1.5;
//                imageView.frame = rect;
                
                switch (image)
                {
                    case 0:
                        //left
//                        [imageView setImage:[UIImage imageWithColor:[UIColor redColor]]];
                        [imageView setImage:[UIImage imageNamed:@"mapAnnoLeft"]];
                        
                        NSLog(@"left view %@", imageView);
                        break;
                    case 1:
                        //right
//                        [imageView setImage:[UIImage imageWithColor:[UIColor blueColor]]];
                        [imageView setImage:[UIImage imageNamed:@"mapAnnoRight"]];
                        
                        NSLog(@"right view %@", imageView);
                        break;
                    case 3:
                        //arrow
//                        [imageView setImage:[UIImage imageWithColor:[UIColor greenColor]]];
                        [imageView setImage:[UIImage imageNamed:@"mapAnnoArrow"]];
                        NSLog(@"arrow view %@", imageView);
                        break;
//                    case 4:
//                        [imageView setImage:[UIImage imageWithColor:[UIColor purpleColor]]];
//                        NSLog(@"4 view %@", imageView);
//                        break;
//                    case 5:
//                        [imageView setImage:[UIImage imageWithColor:[UIColor orangeColor]]];
//                        NSLog(@"5 view %@", imageView);
//                        break;
                    default:
                        //mid
//                        [imageView setImage:[UIImage imageWithColor:[UIColor yellowColor]]];
                        [imageView setImage:[UIImage imageNamed:@"mapAnnoMid"]];
                        
                        UIImage *gasIconImage = [UIImage imageNamed:@"mapCalloutGas"];
                        UIImageView *gasIcon = [[UIImageView alloc] initWithImage:gasIconImage];
                        gasIcon.frame = CGRectMake(10, 6, gasIconImage.size.width, gasIconImage.size.height);
                        [imageView.superview addSubview:gasIcon];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 30)];
                        label.backgroundColor = [UIColor clearColor];
                        label.textColor = [UIColor whiteColor];
                        label.font = [UIFont regularFontOfSize:16];
                        label.text = @"Holiday Oil";
                        [imageView.superview addSubview:label];
                        
                        UIView *tapView = [[UIView alloc] initWithFrame:imageView.superview.bounds];
                        tapView.backgroundColor = [UIColor clearColor];
                        tapView.userInteractionEnabled = YES;
                        [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapCalloutTapped:)]];
                        [imageView.superview addSubview:tapView];
                        
                        NSLog(@"mid view %d, %@", image, imageView);
                        break;
                }
                image++;
            }
            else
                [subsubView removeFromSuperview];
        }
        
//        subview.backgroundColor = [UIColor clearColor];
        
//        [subview addSubview:self.customView];
        
        NSLog(@"calloutFrame %@", subview);
        NSLog(@"mapAnnotationView frame %@", self);
    }
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
