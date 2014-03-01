//
//  MapAnnotationView.m
//  FuelOperator
//
//  Created by Gary Robinson on 4/27/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "MapAnnotationView.h"
#import "InspectionsListCellView.h"
#import "InspectionFormViewController.h"

@interface ArrowView : UIView

@end

@implementation ArrowView

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [UIColor fopOffWhiteColor].CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 10, 10);
    CGContextAddLineToPoint(context, 20, 00);
    CGContextAddLineToPoint(context, 0, 0);
    
    CGContextFillPath(context);
}

@end

@interface MapAnnotationView ()
{
    float _offset;
}
@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic, strong) ArrowView *arrowView;
@property (nonatomic, strong) InspectionsListCellView *inspectionView;
@property (nonatomic) CGFloat calloutOffset;

@end

@implementation MapAnnotationView

- (void)setInspection:(Inspection *)inspection
{
    _inspection = inspection;
    
    self.inspectionView.inspection = inspection;
}

- (InspectionsListCellView *)inspectionView
{
    if(_inspectionView == nil)
    {
        _inspectionView = [[InspectionsListCellView alloc] initWithFrame:CGRectMake(0,0,280,80)];
        [_inspectionView applyMapStyle];
    }
    return _inspectionView;
}

- (ArrowView *)arrowView
{
    if(_arrowView == nil)
    {
        _arrowView = [[ArrowView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
        _arrowView.backgroundColor = [UIColor clearColor];
    }
    return _arrowView;
}

- (UIView *)calloutView
{
    if(_calloutView == nil)
    {
        _calloutView = [[UIView alloc] initWithFrame:CGRectMake(0,0,280,80)];
        _calloutView.backgroundColor = [UIColor fopOffWhiteColor];
        
        [_calloutView addSubview:self.inspectionView];
        
        _calloutView.userInteractionEnabled = YES;
        [_calloutView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calloutTapped:)]];
        
        _calloutView.layer.cornerRadius = 5;
        _calloutView.layer.shadowOpacity = 0.8;
        _calloutView.layer.shadowOffset = CGSizeMake(5, 5);
        _calloutView.layer.shadowRadius = 10;
        _calloutView.layer.masksToBounds = NO;
    }
    return _calloutView;
}

- (void)calloutTapped:(id)sender
{
    NSLog(@"calloutTapped");
    
    InspectionFormViewController *inspectionFormVC = [[InspectionFormViewController alloc] init];
    CGRect test = inspectionFormVC.view.frame;
    inspectionFormVC.inspection = self.inspection;
    [self.delegate.navigationController pushViewController:inspectionFormVC animated:YES];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected)
    {
        CGRect frame = self.calloutView.frame;
        frame.origin.x = self.bounds.origin.x - frame.size.width/2 + self.bounds.size.width/2;
        _offset = self.frame.origin.x + frame.origin.x - 20;
        frame.origin.x -= _offset;
        frame.origin.y = self.bounds.origin.y - frame.size.height - 10;
        self.calloutView.frame = frame;
        //?? this is the bounds of the pin, so I need to offset my custom view from this
        
        self.inspection = _inspection;
        
        [self addSubview:self.calloutView];
        
        //?? needs a little work for when pin is right next to right or left edge
        //?? maybe need to pan the map down if pin is right near the top too
        self.arrowView.frame = CGRectMake(0, self.bounds.origin.y - 10, 20, 10);
        [self addSubview:self.arrowView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
        [self.arrowView removeFromSuperview];
    }
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView == nil && self.selected)
    {
        CGPoint pt = [self convertPoint:point toView:self.calloutView];
        hitView = [self.calloutView hitTest:pt withEvent:event];
//        if(hitView)
//            NSLog(@"HitTest yes");
//        NSLog(@"hitTest %f, %f", pt.x, pt.y);
    }
    return hitView;
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


