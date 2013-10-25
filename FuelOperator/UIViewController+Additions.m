//
//  UIViewController+Additions.m
//  FuelOperator
//
//  Created by Gary Robinson on 10/25/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

- (void)useCustomBackButton
{
    if(self.navigationItem)
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backImage = [UIImage imageNamed:@"btn-back"];
        [backButton setImage:backImage forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
        [backButton addTarget:self action:@selector(customBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
}

- (void)customBackButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
