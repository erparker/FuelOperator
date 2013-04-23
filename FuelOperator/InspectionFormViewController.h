//
//  InspectionFormViewController.h
//  FuelOperator
//
//  Created by Gary Robinson on 3/16/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionFormViewController : UIViewController

@property (nonatomic, strong) NSString *formTitle;

-(void)didSelectAccessory:(id)sender event:(id)event;

@end
