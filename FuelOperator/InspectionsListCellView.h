//
//  InspectionsListCellView.h
//  FuelOperator
//
//  Created by Gary Robinson on 3/15/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INSPECTIONS_LIST_CELL_HEIGHT 80

@interface InspectionsListCellView : UIView

- (void)setName:(NSString *)name withAddressLine1:(NSString*)line1 andAddressLine2:(NSString*)line2;

@end
