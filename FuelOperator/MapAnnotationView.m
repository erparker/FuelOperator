//
//  MapAnnotationView.m
//  FuelOperator
//
//  Created by Gary Robinson on 4/27/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "MapAnnotationView.h"

@interface MapAnnotationView ()

@end

@implementation MapAnnotationView


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
                switch (image)
                {
                    case 0:
                        [imageView setImage:[UIImage imageNamed:@"mapAnnoLeft"]];
                        break;
                    case 1:
                        [imageView setImage:[UIImage imageNamed:@"mapAnnoRight"]];
                        break;
                    case 3:
                        [imageView setImage:[UIImage imageNamed:@"mapAnnoArrow"]];
                        break;
                    default:
                        [imageView setImage:[UIImage imageNamed:@"mapAnnoMid"]];
                        
                        UIImage *gasIconImage = [UIImage imageNamed:@"mapCalloutGas"];
                        UIImageView *gasIcon = [[UIImageView alloc] initWithImage:gasIconImage];
                        gasIcon.frame = CGRectMake(10, 7, gasIconImage.size.width, gasIconImage.size.height);
                        [imageView.superview addSubview:gasIcon];
                        
                        UILabel *annoTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 200, 30)];
                        annoTitle.backgroundColor = [UIColor clearColor];
                        annoTitle.textColor = [UIColor whiteColor];
                        annoTitle.font = [UIFont regularFontOfSize:16];
                        annoTitle.text = self.annotationTitle;
                        [imageView.superview addSubview:annoTitle];
                        
                        UILabel *annoSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 27, 200, 30)];
                        annoSubtitle.backgroundColor = [UIColor clearColor];
                        annoSubtitle.textColor = [UIColor fopDarkText];
                        annoSubtitle.font = [UIFont regularFontOfSize:16];
                        annoSubtitle.text = self.annotationSubtitle;
                        [imageView.superview addSubview:annoSubtitle];
                        
                        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)/*imageView.superview.bounds*/];
                        tapView.backgroundColor = [UIColor clearColor];
                        tapView.userInteractionEnabled = YES;
                        [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(mapCalloutTapped:)]];
                        [imageView.superview addSubview:tapView];
                        [imageView.superview bringSubviewToFront:tapView];
                        
                        break;
                }
                image++;
            }
            else
                [subsubView removeFromSuperview];
        }
        
    }
}

//- (void)mapCalloutTapped:(id)sender
//{
//    NSLog(@"fuck");
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
