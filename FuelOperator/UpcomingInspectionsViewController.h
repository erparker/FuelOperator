//
//  UpcomingInspectionsViewController.h
//  FuelOperator
//
//  Created by Gary Robinson on 2/26/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@interface UpcomingInspectionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IIViewDeckController *viewDeckController;

@end
