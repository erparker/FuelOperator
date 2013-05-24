//
//  RootContainerViewController.m
//  FuelOperator
//
//  Created by Gary Robinson on 5/24/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "RootContainerViewController.h"
#import "SettingsViewController.h"
#import "UpcomingInspectionsViewController.h"

#define OPEN_WIDTH 60

@interface RootContainerViewController ()

@property (nonatomic, strong) UINavigationController *inspectionsNC;
@property (nonatomic, strong) SettingsViewController *settingsVC;
@property (nonatomic, strong) UIView *blockingView;
@property (nonatomic) BOOL settingsOpen;
@property (nonatomic) CGFloat startPosition;

@end

@implementation RootContainerViewController

- (void)loadView
{
    [super loadView];
    
    self.settingsOpen = NO;
    
    [self addChildViewController:self.settingsVC];
    [self.view addSubview:self.settingsVC.view];
    [self.settingsVC didMoveToParentViewController:self];
    
    [self addChildViewController:self.inspectionsNC];
    [self.view addSubview:self.inspectionsNC.view];
    [self.inspectionsNC didMoveToParentViewController:self];
}

- (UINavigationController*)inspectionsNC
{
    if(_inspectionsNC == nil)
    {
        UpcomingInspectionsViewController *upcomingInspectionsVC = [[UpcomingInspectionsViewController alloc] init];
        _inspectionsNC = [[UINavigationController alloc] initWithRootViewController:upcomingInspectionsVC];
        [_inspectionsNC.navigationBar addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mainNavPanned:)]];
    }
    return _inspectionsNC;
}

- (SettingsViewController*)settingsVC
{
    if(_settingsVC == nil)
    {
        _settingsVC = [[SettingsViewController alloc] init];
    }
    return _settingsVC;
}

- (void)viewWillLayoutSubviews
{
    self.inspectionsNC.view.frame = self.view.bounds;
    self.settingsVC.view.frame = self.view.bounds;
}

- (UIView *)blockingView
{
    if(_blockingView == nil)
    {
        CGFloat height = self.inspectionsNC.visibleViewController.view.frame.size.height;
        _blockingView = [[UIView alloc] initWithFrame:CGRectMake(0, self.inspectionsNC.view.frame.size.height - height, self.inspectionsNC.visibleViewController.view.frame.size.width, height)];
        _blockingView.backgroundColor = [UIColor clearColor];
        _blockingView.userInteractionEnabled = YES;
        [_blockingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockingViewTapped:)]];
    }
    return _blockingView;
}

- (void)blockingViewTapped:(id)sender
{
    [self toggleOpen];
}

- (void)mainNavPanned:(UIPanGestureRecognizer *)pan
{
    if(pan.state == UIGestureRecognizerStateBegan)
        self.startPosition = self.inspectionsNC.view.frame.origin.x;
    
    CGPoint pt = [pan translationInView:self.inspectionsNC.navigationBar];
    CGFloat newOriginX = self.startPosition + pt.x;
    if(newOriginX < 0)
        newOriginX = 0;
    if(newOriginX > self.inspectionsNC.view.frame.size.width - OPEN_WIDTH)
        newOriginX = self.inspectionsNC.view.frame.size.width - OPEN_WIDTH;
    
    CGRect rect = self.inspectionsNC.view.frame;
    rect.origin.x = newOriginX;
    self.inspectionsNC.view.frame = rect;
    
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        if([pan velocityInView:self.inspectionsNC.navigationBar].x < 0)
            self.settingsOpen = YES;
        else
            self.settingsOpen = NO;
        
        [self toggleOpen];
    }
}

- (void)toggleOpen
{
    CGRect rect = self.inspectionsNC.view.frame;
    if(!self.settingsOpen)
        rect.origin.x = self.view.bounds.size.width - OPEN_WIDTH;
    else
        rect.origin.x = 0;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void)
     {
         self.inspectionsNC.view.frame = rect;
         
     } completion:^(BOOL finished){
         
         self.settingsOpen = !self.settingsOpen;
         
         //?? if menuOpen, any touch on mainVC should close it
         if(self.settingsOpen)
             [self.inspectionsNC.view addSubview:self.blockingView];
         else
             [self.blockingView removeFromSuperview];
         
     }];
}

@end
