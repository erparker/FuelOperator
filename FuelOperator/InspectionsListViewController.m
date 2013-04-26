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

#define INSPECTIONS_LIST_CELL_VIEW_TAG 3

@interface InspectionsListViewController () <MKMapViewDelegate>

@property (nonatomic, strong) UISegmentedControl *listMapControl;
@property (nonatomic, strong) UIButton *addSiteBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleDateLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *switchView;

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
    
    self.navigationItem.titleView = self.listMapControl;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addSiteBtn];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.switchView];
    [self.switchView addSubview:self.mapView];
    [self.switchView addSubview:self.tableView];
    
    //this just forces proper initialization of the map view
    //[self.switchView addSubview:self.mapView];
    //[self.mapView removeFromSuperview];
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

//?? I should replace this with 2 buttons side by side
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
        CGFloat a = self.view.bounds.size.height;
        CGFloat b = self.view.frame.size.height;
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
    }
    return _mapView;
}

- (void)locationTapped:(id)sender
{
    NSLog(@"locationTapped\n");
}

@end
