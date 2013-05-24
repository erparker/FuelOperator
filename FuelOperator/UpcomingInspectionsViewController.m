//
//  UpcomingInspectionsViewController.m
//  FuelOperator
//
//  Created by Gary Robinson on 2/26/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "UpcomingInspectionsViewController.h"
#import "UpcomingInspectionsCellView.h"
#import "InspectionsListViewController.h"
#import "AppDelegate.h"

#define UPCOMING_INSPECTIONS_CELL_VIEW_TAG 2
#define HEADER_HEIGHT 25

@interface UpcomingInspectionsViewController ()

@property (nonatomic, strong) UIButton *settingsBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *addSiteBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDate *startOfThisWeek;
@property (nonatomic) BOOL settingsOpen;

@end

@implementation UpcomingInspectionsViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingsBtn];
    self.navigationItem.titleView = self.titleLabel;
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addSiteBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.settingsOpen = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton*)settingsBtn
{
    if(_settingsBtn == nil)
    {
        _settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingsBtn.frame = CGRectMake(0, 0, 31, 31);
        [_settingsBtn setImage:[UIImage imageNamed:@"btn-settings.png"] forState:UIControlStateNormal];
        [_settingsBtn addTarget:self action:@selector(toggleLeftView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingsBtn;
}

- (void)toggleLeftView:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)([[UIApplication sharedApplication] delegate]);
    [appDelegate.rootViewController toggleOpen];
}

- (UILabel *)titleLabel
{
    if(_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"Upcoming Inspections";
        _titleLabel.font = [UIFont boldFontOfSize:18];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_titleLabel sizeToFit];
        _titleLabel.center = CGPointMake(self.view.bounds.size.width/2.0, 20);
    }
    return _titleLabel;
}

- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor fopWhiteColor];
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, tableView.bounds.size.width, HEADER_HEIGHT);
    UIView *headerView = [[UIView alloc] initWithFrame:rect];
    headerView.backgroundColor = [UIColor fopYellowColor];
    
    rect.origin.x = 5;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:rect];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldFontOfSize:18];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.numberOfLines = 1;
    
    //based off the current date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    NSDate *now = [NSDate date];
    
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:now];
    int currentWeekday = [weekdayComponents weekday]; //[1;7] ... 1 is sunday, 7 is saturday in gregorian calendar
    self.startOfThisWeek = [now dateByAddingTimeInterval:-60.0 * 60.0 * 24.0 * (currentWeekday - 1)];
    
    if(section == 0)
    {
        NSDate *endOfWeek = [self.startOfThisWeek dateByAddingTimeInterval:60.0 * 60.0 * 24.0 * 6.0];
        headerLabel.text = [NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:self.startOfThisWeek], [formatter stringFromDate:endOfWeek]];
    }
    else
    {
        NSDate *weekFromStart = [self.startOfThisWeek dateByAddingTimeInterval:60.0 * 60.0 * 24.0 * 7.0];
        NSDate *endOfWeekFromNow = [self.startOfThisWeek dateByAddingTimeInterval:60.0 * 60.0 * 24.0 * 13.0];
        headerLabel.text = [NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:weekFromStart], [formatter stringFromDate:endOfWeekFromNow]];
    }
    
    [headerLabel sizeToFit];
    headerLabel.frame = CGRectMake(5, 6, tableView.bounds.size.width - 5, headerLabel.frame.size.height);
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UPCOMING_INSPECTIONS_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"upcomingInspectionCell";
    
    UpcomingInspectionsCellView *cellView = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
        cellView = [[UpcomingInspectionsCellView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.width)];
        cellView.tag = UPCOMING_INSPECTIONS_CELL_VIEW_TAG;
        [cell.contentView addSubview:cellView];
    }
    else
    {
        cellView = (UpcomingInspectionsCellView *)[cell.contentView viewWithTag:UPCOMING_INSPECTIONS_CELL_VIEW_TAG];
    }
    
    if(indexPath.row == 0)
        [cellView setDayTitle:@"Monday" withNumInspections:8];
    else if(indexPath.row == 1)
        [cellView setDayTitle:@"Tuesday" withNumInspections:6];
    else if(indexPath.row == 2)
        [cellView setDayTitle:@"Wednesday" withNumInspections:7];
    else if(indexPath.row == 3)
        [cellView setDayTitle:@"Thursday" withNumInspections:7];
    else
        [cellView setDayTitle:@"Friday" withNumInspections:4];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.navigationItem.title = @" ";
    
    //format the date selected here like: "Mon Oct 6, 2012"
    NSDate *dateSelected = [self.startOfThisWeek dateByAddingTimeInterval:60.0 * 60.0 * 24.0 * (1 + indexPath.row + 7 * indexPath.section)];
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EE"];
    NSString *day = [dayFormatter stringFromDate:dateSelected];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:dateSelected];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    int monthIndex = [components month] - 1;
    NSString *monthName = [[formatter monthSymbols] objectAtIndex:monthIndex];
    monthName = [monthName substringToIndex:3];
    
    [formatter setDateFormat:@"dd, yyyy"];
    NSString *dayAndYear = [formatter stringFromDate:dateSelected];
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %@ %@", day, monthName, dayAndYear];
    
    InspectionsListViewController *inspectionsListVC = [[InspectionsListViewController alloc] init];
    [inspectionsListVC setDateString:dateString];
    [self.navigationController pushViewController:inspectionsListVC animated:YES];
}



@end
