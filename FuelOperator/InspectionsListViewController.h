//
//  InspectionsListViewController.h
//  FuelOperator
//
//  Created by Gary Robinson on 3/15/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *dateString;

@end
