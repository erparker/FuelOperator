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
@property (nonatomic, strong) NSArray *mapAnnotations;

@end

@implementation InspectionsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black-noise"]];
    
    self.navigationItem.titleView = self.listMapControl;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addSiteBtn];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.switchView];
    [self.switchView addSubview:self.mapView];
    [self.switchView addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UISegmentedControl*)listMapControl
{
    if(_listMapControl == nil)
    {
        UIImage *listImage = [UIImage imageNamed:@"listView"];
        UIImage *mapImage = [UIImage imageNamed:@"mapView"];
        NSArray *items = [[NSArray alloc] initWithObjects:listImage, mapImage, nil];
        _listMapControl = [[UISegmentedControl alloc] initWithItems:items];
        _listMapControl.frame = CGRectMake(320/2 - 170/2, 10, 170, 30);
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
    return 8;
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
    
    if(indexPath.row == 0)
        [cellView setName:@"Holiday Oil" withAddressLine1:@"9854 N 5400 W" andAddressLine2:@"Draper, Utah 84947"];
    else if(indexPath.row == 1)
        [cellView setName:@"Sinclair" withAddressLine1:@"710 Washington Blvd. E. 700 S" andAddressLine2:@"Ogden, Utah 84004"];
    else if(indexPath.row == 2)
        [cellView setName:@"Texaco" withAddressLine1:@"354 State St" andAddressLine2:@"Payson, Utah 84567"];
    else if(indexPath.row == 3)
        [cellView setName:@"Kicks 66" withAddressLine1:@"5619 E 4298 S" andAddressLine2:@"Delta, Utah 84947"];
    else if(indexPath.row == 4)
        [cellView setName:@"Maverick" withAddressLine1:@"5948 Redwood Rd" andAddressLine2:@"West Jordan, Utah 84947"];
    else if(indexPath.row == 5)
        [cellView setName:@"7-Eleven" withAddressLine1:@"11657 S 9000 E" andAddressLine2:@"Draper, Utah 84947"];
    else if(indexPath.row == 6)
        [cellView setName:@"Texaco" withAddressLine1:@"710 Washington Blvd. E. 700 S" andAddressLine2:@"Lehi, Utah 84045"];
    else if(indexPath.row == 7)
        [cellView setName:@"Crest" withAddressLine1:@"710 Washington Blvd. E. 700 S" andAddressLine2:@"Ogden, Utah 84004"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.navigationItem.title = @" ";
    
    InspectionFormViewController *inspectionFormVC = [[InspectionFormViewController alloc] init];
    
    if(indexPath.row == 0)
        inspectionFormVC.formTitle = @"Holiday Oil - Draper, UT";
    else if(indexPath.row == 1)
        inspectionFormVC.formTitle = @"Sinclair - Sandy, UT";
    else if(indexPath.row == 2)
        inspectionFormVC.formTitle = @"Texaco - Payson, UT";
    else if(indexPath.row == 3)
        inspectionFormVC.formTitle = @"Kicks 66 - Delta, UT";
    else if(indexPath.row == 4)
        inspectionFormVC.formTitle = @"Maverick - West Jordan, UT";
    else if(indexPath.row == 5)
        inspectionFormVC.formTitle = @"7-Eleven - Draper, UT";
    else if(indexPath.row == 6)
        inspectionFormVC.formTitle = @"Texaco - Lehi, UT";
    else if(indexPath.row == 7)
        inspectionFormVC.formTitle = @"Crest - Ogden, UT";
    
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
        
        //populate an array of pin annotations for the map
        MapAnnotation *anno1 = [[MapAnnotation alloc] init];
        anno1.coordinate = CLLocationCoordinate2DMake(40.525863,-111.863403);
        anno1.annotationTitle = @"Holiday Oil";
        anno1.annotationSubtitle = @"Draper, UT";
        anno1.title = @" ";
        anno1.subtitle = @" ";
        [_mapView addAnnotation:anno1];
        
        MapAnnotation *anno2 = [[MapAnnotation alloc] init];
        anno2.coordinate = CLLocationCoordinate2DMake(40.573863,-111.899109);
        anno2.annotationTitle = @"Sinclair";
        anno2.annotationSubtitle = @"Sandy, UT";
        anno2.title = @" ";
        anno2.subtitle = @" ";
        [_mapView addAnnotation:anno2];
        
        MapAnnotation *anno3 = [[MapAnnotation alloc] init];
        anno3.coordinate = CLLocationCoordinate2DMake(40.041868,-111.701355);
        anno3.annotationTitle = @"Texaco";
        anno3.annotationSubtitle = @"Payson, UT";
        anno3.title = @" ";
        anno3.subtitle = @" ";
        [_mapView addAnnotation:anno3];
        
        MapAnnotation *anno4 = [[MapAnnotation alloc] init];
        anno4.coordinate = CLLocationCoordinate2DMake(39.352178,-112.57717);
        anno4.annotationTitle = @"Kicks 66";
        anno4.annotationSubtitle = @"Delta, UT";
        anno4.title = @" ";
        anno4.subtitle = @" ";
        [_mapView addAnnotation:anno4];
        
        MapAnnotation *anno5 = [[MapAnnotation alloc] init];
        anno5.coordinate = CLLocationCoordinate2DMake(40.607466,-111.955109);
        anno5.annotationTitle = @"Maverick";
        anno5.annotationSubtitle = @"West Jordan, UT";
        anno5.title = @" ";
        anno5.subtitle = @" ";
        [_mapView addAnnotation:anno5];
        
        MapAnnotation *anno6 = [[MapAnnotation alloc] init];
        anno6.coordinate = CLLocationCoordinate2DMake(40.511479,-111.878204);
        anno6.annotationTitle = @"7-Eleven";
        anno6.annotationSubtitle = @"Draper, UT";
        anno6.title = @" ";
        anno6.subtitle = @" ";
        [_mapView addAnnotation:anno6];
        
        MapAnnotation *anno7 = [[MapAnnotation alloc] init];
        anno7.coordinate = CLLocationCoordinate2DMake(40.391302,-111.849365);
        anno7.annotationTitle = @"Texaco";
        anno7.annotationSubtitle = @"Lehi, UT";
        anno7.title = @" ";
        anno7.subtitle = @" ";
        [_mapView addAnnotation:anno7];
        
        MapAnnotation *anno8 = [[MapAnnotation alloc] init];
        anno8.coordinate = CLLocationCoordinate2DMake(41.220789,-111.985321);
        anno8.annotationTitle = @"Crest";
        anno8.annotationSubtitle = @"Ogden, UT";
        anno8.title = @" ";
        anno8.subtitle = @" ";
        [_mapView addAnnotation:anno8];
        
        self.mapAnnotations = [NSArray arrayWithObjects:anno1, anno2, anno3, anno4, anno5, anno6, anno7, anno8, nil];
        
        
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
        mapView.annotationTitle = mapAnnotation.annotationTitle;
        mapView.annotationSubtitle = mapAnnotation.annotationSubtitle;
        mapView.delegate = self;
        
        aView = mapView;
    }
    
    // set canShowCallout to YES and build aView’s callout accessory views here }
    aView.canShowCallout = YES;
    aView.annotation = annotation; // yes, this happens twice if no dequeue
    
    UIView* popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAP_ANNOTATION_VIEW_WIDTH, MAP_ANNOTATION_VIEW_HEIGHT)];
    //popupView.backgroundColor = [UIColor fopYellowColor];
    aView.leftCalloutAccessoryView = popupView;
    
    return aView;
}

- (void)mapCalloutTapped:(id)sender
{
    NSLog(@"mapCalloutTapped");
}

- (void)locationTapped:(id)sender
{
    //?? change the center of the map to the current location
    //?? make the span 1.0 instead of 2.0
    NSLog(@"locationTapped\n");
}

@end
