//
//  CommentPhotoViewController.h
//  FuelOperator
//
//  Created by Gary Robinson on 3/29/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormCategoryView.h"

@interface CommentPhotoViewController : UIViewController

- (id)initWithAnswer:(FormAnswer *)answer;

@property (nonatomic, weak) id <FormCategoryDelegate> formCategoryDelegate;



@end
