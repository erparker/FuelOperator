//
//  MapAnnotation.h
//  FuelOperator
//
//  Created by Gary Robinson on 4/27/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, strong) Inspection *inspection;
@property (nonatomic, strong) NSString *annotationTitle;
@property (nonatomic, strong) NSString *annotationSubtitle;

@end
