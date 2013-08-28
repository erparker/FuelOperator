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

@property (nonatomic, strong) Inspection *inspection;
@property (nonatomic, strong) NSString *annotationTitle;
@property (nonatomic, strong) NSString *annotationSubtitle;

@property (nonatomic, weak) UIViewController *delegate;

@end


@interface MapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) Inspection *inspection;
@property (nonatomic, strong) NSString *annotationTitle;
@property (nonatomic, strong) NSString *annotationSubtitle;

@end