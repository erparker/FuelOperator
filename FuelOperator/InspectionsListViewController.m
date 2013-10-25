//
//  InspectionsListViewController.m
//  FuelOperator
//
//  Created by Gary Robinson on 3/15/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "InspectionsListViewController.h"
#import "InspectionsListCellView.h"
#import <MapKit/MapKit.h>
#import "InspectionFormViewController.h"
#import "MapAnnotation.h"
#import "MapAnnotationView.h"

#define INSPECTIONS_LIST_CELL_VIEW_TAG 3

@interface InspectionsListViewController () <MKMapViewDelegate>

@property (nonatomic, strong) UISegmentedControl *listMapControl;
@property (nonatomic, strong) UIButton *addSiteBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleDateLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *switchView;

@property (nonatomic, strong) NSArray *inspections;

@end

@implementation InspectionsListViewController

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black-noise"]];
    
    self.navigationItem.titleView = self.listMapControl;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addSiteBtn];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.switchView];
    [self.switchView addSubview:self.mapView];
    [self.switchView addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.navigationItem.title = @"";
    
    [self useCustomBackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    self.inspections = [Inspection MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", _date, [NSDate dateWithNumberOfDays:1 sinceDate:_date]]];
    
    //format the date selected here like: "Mon Oct 6, 2012"
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EE"];
    NSString *day = [dayFormatter stringFromDate:_date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:_date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    int monthIndex = [components month] - 1;
    NSString *monthName = [[formatter monthSymbols] objectAtIndex:monthIndex];
    monthName = [monthName substringToIndex:3];
    
    [formatter setDateFormat:@"dd, yyyy"];
    NSString *dayAndYear = [formatter stringFromDate:_date];
    
    self.dateString = [NSString stringWithFormat:@"%@ %@ %@", day, monthName, dayAndYear];
}

- (UISegmentedControl*)listMapControl
{
    if(_listMapControl == nil)
    {
        CGFloat width = 170;
        _listMapControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - width/2, 10, width, 30)];
        
        UIImage *listImage = [UIImage imageNamed:@"listView"];
        UIImage *mapImage = [UIImage imageNamed:@"mapView"];
        [_listMapControl insertSegmentWithImage:listImage atIndex:0 animated:NO];
        [_listMapControl insertSegmentWithImage:mapImage atIndex:1 animated:NO];
        _listMapControl.selectedSegmentIndex = 0;
        
        [_listMapControl setBackgroundImage:[UIImage imageNamed:@"segemented-background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_listMapControl setBackgroundImage:[UIImage imageNamed:@"segemented-background-selected"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [_listMapControl setDividerImage:[UIImage imageNamed:@"segemented-background"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_listMapControl setDividerImage:[UIImage imageNamed:@"segemented-background"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        _listMapControl.layer.cornerRadius = 5;
        _listMapControl.layer.masksToBounds = YES;
        [_listMapControl addTarget:self action:@selector(toggleListMap:) forControlEvents:UIControlEventValueChanged];
    }
    return _listMapControl;
}

- (void)toggleListMap:(id)sender
{
    [UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.switchView cache:YES];
    
    if(self.listMapControl.selectedSegmentIndex == 0)
    {
        [self.switchView addSubview:self.tableView];
        [self.mapView removeFromSuperview];
    }
    else
    {
        [self.switchView addSubview:self.mapView];
        [self.tableView removeFromSuperview];
    }
    
    [UIView commitAnimations];
}

- (UIButton*)addSiteBtn
{
    if(_addSiteBtn == nil)
    {
        _addSiteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *addSiteImage = [UIImage imageNamed:@"addSite"];
        [_addSiteBtn setImage:addSiteImage forState:UIControlStateNormal];
        _addSiteBtn.frame = CGRectMake(0, 0, addSiteImage.size.width, addSiteImage.size.height);
        [_addSiteBtn addTarget:self action:@selector(addSite:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addSiteBtn;
}

- (void)addSite:(id)sender
{
    NSLog(@"addSite\n");
}

- (UIView*)titleView
{
    if(_titleView == nil)
    {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        _titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black-noise.png"]];
        [_titleView addSubview:self.titleDateLabel];
    }
    return _titleView;
}

- (UILabel*)titleDateLabel
{
    if(_titleDateLabel == nil)
    {
        _titleDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 40)];
        _titleDateLabel.backgroundColor = [UIColor clearColor];
        _titleDateLabel.font = [UIFont thinFontOfSize:36];
        _titleDateLabel.textColor = [UIColor fopLightGreyColor];
        //?? do the day they picked
        _titleDateLabel.text = self.dateString;
    }
    return _titleDateLabel;
}

- (void)setDateString:(NSString *)dateString
{
    _dateString = dateString;
    self.titleDateLabel.text = _dateString;
}

- (UIView*)switchView
{
    if(_switchView == nil)
    {
        _switchView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView.frame.size.height, self.view.bounds.size.width, self.view.frame.size.height - self.titleView.frame.size.height - 50)];
    }
    return _switchView;
}

- (UITableView*)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.switchView.frame.size.width, self.switchView.frame.size.height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor fopOffWhiteColor];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.inspections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return INSPECTIONS_LIST_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"inspectionsListCell";
    
    InspectionsListCellView *cellView = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cellView = [[InspectionsListCellView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.width)];
        cellView.tag = INSPECTIONS_LIST_CELL_VIEW_TAG;
        [cell.contentView addSubview:cellView];
    }
    else
    {
        cellView = (InspectionsListCellView *)[cell.contentView viewWithTag:INSPECTIONS_LIST_CELL_VIEW_TAG];
    }
    
    Inspection *inspection = [self.inspections objectAtIndex:indexPath.row];
    cellView.station = inspection.station;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.navigationItem.title = @" ";
    
    InspectionFormViewController *inspectionFormVC = [[InspectionFormViewController alloc] init];
    
    Inspection *inspection = [self.inspections objectAtIndex:indexPath.row];
    inspectionFormVC.inspection = inspection;
    
    [self.navigationController pushViewController:inspectionFormVC animated:YES];
}

- (MKMapView*)mapView
{
    if(_mapView == nil)
    {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.switchView.frame.size.width, self.switchView.frame.size.height)];
        _mapView.delegate = self;
        
        UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *locationImage = [UIImage imageNamed:@"location"];
        [locationButton setImage:locationImage forState:UIControlStateNormal];
        locationButton.frame = CGRectMake(10, _mapView.frame.size.height - 10 - locationImage.size.height, locationImage.size.width, locationImage.size.height);
        [locationButton addTarget:self action:@selector(locationTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_mapView addSubview:locationButton];
        
        for(NSUInteger i=0; i<self.inspections.count; i++)
        {
            Inspection *inspection = [self.inspections objectAtIndex:i];
//            Station *station = [self.stations objectAtIndex:i];
            MapAnnotation *anno = [[MapAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake([inspection.station.location.lattitude floatValue], [inspection.station.location.longitude floatValue]);
            anno.inspection = inspection;
            anno.annotationTitle = inspection.station.companyName;
            anno.annotationSubtitle = [NSString stringWithFormat:@"%@, %@", inspection.station.location.city, inspection.station.location.state];
            anno.title = @" ";
            anno.subtitle = @" ";
            [_mapView addAnnotation:anno];
        }
        
        //set the starting view of the map - slc, northern utah
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(40.770951,-112.13501); //slc
        _mapView.region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(2.0, 2.0));
    }
    return _mapView;
}

- (MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *aView = [sender dequeueReusableAnnotationViewWithIdentifier:@"mapAnnotation"];
    if(!aView)
    {
        MapAnnotationView *mapView = [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapAnnotation"];
        mapView.image = [UIImage imageNamed:@"mappin"];
        
        MapAnnotation *mapAnnotation = (MapAnnotation *)annotation;
        mapView.inspection = mapAnnotation.inspection;
        mapView.annotationTitle = mapAnnotation.annotationTitle;
        mapView.annotationSubtitle = mapAnnotation.annotationSubtitle;
        mapView.delegate = self;
        
        aView = mapView;
    }
    
    aView.canShowCallout = YES;
    aView.annotation = annotation; 
    UIView* popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAP_ANNOTATION_VIEW_WIDTH, MAP_ANNOTATION_VIEW_HEIGHT)];
    aView.leftCalloutAccessoryView = popupView;
    
    return aView;
}

- (void)mapCalloutTapped:(id)sender
{
    self.navigationItem.title = @" ";
    
    MapGestureRecognizer *mapGesture = (MapGestureRecognizer *)sender;
    
    InspectionFormViewController *inspectionFormVC = [[InspectionFormViewController alloc] init];
    inspectionFormVC.inspection = mapGesture.inspection;
    [self.navigationController pushViewController:inspectionFormVC animated:YES];
}

- (void)locationTapped:(id)sender
{
    //?? change the center of the map to the current location
    //?? make the span 1.0 instead of 2.0
    //?? zoom it so that all the pins can be seen
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(40.770951,-112.13501); //slc
    self.mapView.region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(2.0, 2.0));
}

@end
