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
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDate *startOfThisWeek;
@property (nonatomic) BOOL settingsOpen;
@property (nonatomic) BOOL firstAppear;

@end

@implementation UpcomingInspectionsViewController

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingsBtn];
    self.navigationItem.titleView = self.titleLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.settingsOpen = NO;
    self.firstAppear = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inspectionsUpdated:) name:@"inspectionsUpdated" object:nil];
    [self updateInspections];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.firstAppear)
    {
        self.firstAppear = NO;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateInspections
{
    NSDate *start = [NSDate dateWithNumberOfDays:-14 sinceDate:[NSDate startOfTheWeekFromToday]];
    NSDate *end = [NSDate dateWithNumberOfDays:6*7 sinceDate:start];
    [[OnlineService sharedService] updateInspectionsFromDate:start toDate:end];
}

- (void)inspectionsUpdated:(id)sender
{
    [self.tableView reloadData];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor fopWhiteColor];
    }
    return _tableView;
}

- (NSDate *)startOfThisWeek
{
    if(_startOfThisWeek == nil)
    {
        _startOfThisWeek = [NSDate startOfTheWeekFromToday];
    }
    return _startOfThisWeek;
}


- (NSInteger)sectionMultiplier:(NSInteger)section
{
    //also shows the previous 2 weeks
    return (section - 2);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 6;
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
    
    NSDate *startOfWeek = [self.startOfThisWeek dateByAddingTimeInterval:[NSDate secondsPerDay] * 7.0 * [self sectionMultiplier:section]];
    NSDate *endOfWeek = [self.startOfThisWeek dateByAddingTimeInterval:[NSDate secondsPerDay] * (6.0 + 7.0 * [self sectionMultiplier:section])];
    headerLabel.text = [NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:startOfWeek], [formatter stringFromDate:endOfWeek]];
    
    [headerLabel sizeToFit];
    headerLabel.frame = CGRectMake(5, 6, tableView.bounds.size.width - 5, headerLabel.frame.size.height);
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
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
    
    NSString *dayTitle;
    if(indexPath.row == 0)
        dayTitle = @"Sunday";
    else if(indexPath.row == 1)
        dayTitle = @"Monday";
    else if(indexPath.row == 2)
        dayTitle = @"Tuesday";
    else if(indexPath.row == 3)
        dayTitle = @"Wednesday";
    else if(indexPath.row == 4)
        dayTitle = @"Thursday";
    else if(indexPath.row == 5)
        dayTitle = @"Friday";
    else
        dayTitle = @"Saturday";
    
    [cellView setDayTitle:dayTitle withNumInspections:[self numInspectionsWithIndexPath:indexPath]];
    
    return cell;
}

- (NSInteger)numInspectionsWithIndexPath:(NSIndexPath *)indexPath
{
    NSDate *startDate;
    NSDate *endDate;
    
    startDate = [NSDate dateWithNumberOfDays:(indexPath.row + 7 * [self sectionMultiplier:indexPath.section]) sinceDate:self.startOfThisWeek];
    endDate = [NSDate dateWithNumberOfDays:1 sinceDate:startDate];
    
    NSArray *inspections = [Inspection MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", startDate, endDate]];
    return inspections.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    InspectionsListViewController *inspectionsListVC = [[InspectionsListViewController alloc] init];
    NSDate *dateSelected = [self.startOfThisWeek dateByAddingTimeInterval:[NSDate secondsPerDay] * (indexPath.row + 7 * [self sectionMultiplier:indexPath.section])];
    inspectionsListVC.date = dateSelected;
    [self.navigationController pushViewController:inspectionsListVC animated:YES];
}






@end
