//
//  UpcomingInspectionsCellView.h
//  FuelOperator
//
//  Created by Gary Robinson on 3/13/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UPCOMING_INSPECTIONS_CELL_HEIGHT 55

@interface UpcomingInspectionsCellView : UIView

- (void)setDayTitle:(NSString*)title withNumInspections:(NSUInteger)numInspections;

@end
