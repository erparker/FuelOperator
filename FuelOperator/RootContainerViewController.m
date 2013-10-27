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
@property (nonatomic, strong) UINavigationController *settingsNC;
@property (nonatomic, strong) UIView *blockingView;
@property (nonatomic) BOOL settingsOpen;
@property (nonatomic) CGFloat startPosition;

@end

@implementation RootContainerViewController

- (void)loadView
{
    [super loadView];
    
    self.settingsOpen = NO;
    
    [self addChildViewController:self.settingsNC];
    [self.view addSubview:self.settingsNC.view];
    [self.settingsNC didMoveToParentViewController:self];
    
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
        _inspectionsNC.navigationBar.translucent = NO;
        [_inspectionsNC.navigationBar addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mainNavPanned:)]];
    }
    return _inspectionsNC;
}

- (UINavigationController*)settingsNC
{
    if(_settingsNC == nil)
    {
        SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
        _settingsNC = [[UINavigationController alloc] initWithRootViewController:settingsVC];
        _settingsNC.navigationBar.translucent = NO;
    }
    return _settingsNC;
}

- (void)viewWillLayoutSubviews
{
    self.inspectionsNC.view.frame = self.view.bounds;
    self.settingsNC.view.frame = self.view.bounds;
}

- (UIView *)blockingView
{
    if(_blockingView == nil)
    {
        CGRect rect = CGRectMake(0, 0, self.inspectionsNC.view.frame.size.width, self.inspectionsNC.view.frame.size.height);
        _blockingView = [[UIView alloc] initWithFrame:rect];
        _blockingView.backgroundColor = [UIColor clearColor];
        _blockingView.userInteractionEnabled = YES;
        [_blockingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockingViewTapped:)]];
        [_blockingView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mainNavPanned:)]];
    }
    return _blockingView;
}

- (void)blockingViewTapped:(id)sender
{
    [self toggleOpen];
}

- (void)mainNavPanned:(UIPanGestureRecognizer *)pan
{
    NSLog(@"mainNavPanned");
    
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
         NSLog(@"moving to %f", rect.origin.x);
         self.inspectionsNC.view.frame = rect;
         
     } completion:^(BOOL finished){
         
         CGFloat afterX = self.inspectionsNC.view.frame.origin.x;
         NSLog(@"afterX = %f", afterX);
         
         self.settingsOpen = !self.settingsOpen;
         
         //?? if menuOpen, any touch on mainVC should close it
         if(self.settingsOpen)
             [self.inspectionsNC.view addSubview:self.blockingView];
         else
             [self.blockingView removeFromSuperview];
         
     }];
}

@end
