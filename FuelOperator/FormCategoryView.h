//
//  FormCategoryView.h
//  FuelOperator
//
//  Created by Gary Robinson on 8/27/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BUTTON_HEIGHT 47

@protocol FormCategoryDelegate <NSObject>

- (void)updateProgressView;
- (void)editCommentPhotosForAnswer:(FormAnswer *)formAnswer;

@end

@interface FormCategoryView : UIView

@property (nonatomic, weak) id <FormCategoryDelegate> formCategoryDelegate;

@property (nonatomic) BOOL singleCategory;
@property (nonatomic, strong) Inspection *inspection;
@property (nonatomic, strong) NSArray *formQuestions;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithFrame:(CGRect)frame singleCategory:(BOOL)single;

@end
