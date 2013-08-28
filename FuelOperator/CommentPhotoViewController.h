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

@property (nonatomic, weak) id <FormCategoryDelegate> formCategoryDelegate;

@property (nonatomic, strong) FormAnswer *answer;

//@property (nonatomic, strong) NSString *question;
//@property (nonatomic) NSInteger row;
//@property (nonatomic, strong) NSString *tabName;

@end
