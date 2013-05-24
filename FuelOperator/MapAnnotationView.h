//
//  MapAnnotationView.h
//  FuelOperator
//
//  Created by Gary Robinson on 4/27/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define MAP_ANNOTATION_VIEW_WIDTH 200
#define MAP_ANNOTATION_VIEW_HEIGHT 30

@interface MapAnnotationView : MKAnnotationView

@property (nonatomic, weak) UIViewController *delegate;

@end
