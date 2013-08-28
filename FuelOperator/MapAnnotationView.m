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
                        
                        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 70)];
                        tapView.backgroundColor = [UIColor clearColor];
                        tapView.userInteractionEnabled = YES;
                        MapGestureRecognizer *mapGesture = [[MapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(mapCalloutTapped:)];
                        mapGesture.annotationTitle = self.annotationTitle;
                        mapGesture.annotationSubtitle = self.annotationSubtitle;
                        mapGesture.inspection = self.inspection;
                        [tapView addGestureRecognizer:mapGesture];
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

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    //test touched point in map view
    //when hit test return nil callout close immediately by default
    UIView* hitView = [super hitTest:point withEvent:event];
    // if hittest return nil test touch point
    if (hitView == nil){
        //dig view to find custom touchable view lately added by us
        for(UIView *firstView in self.subviews){
            if([firstView isKindOfClass:[NSClassFromString(@"UICalloutView") class]]){
                for(UIView *touchableView in firstView.subviews){
                    if([touchableView isKindOfClass:[UIView class]]){ //this is our touchable view class
                        //define touchable area
                        CGRect touchableArea = CGRectMake(firstView.frame.origin.x, firstView.frame.origin.y, touchableView.frame.size.width, touchableView.frame.size.height);
                        //test touch point if in touchable area
                        if (CGRectContainsPoint(touchableArea, point)){
                            //if touch point is in touchable area return touchable view as a touched view
                            hitView = touchableView;
                        }
                    }
                }
            }
        }
    }
    return hitView;
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



@implementation MapGestureRecognizer

@end
