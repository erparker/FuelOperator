//
//  SettingsViewController.m
//  FuelOperator
//
//  Created by Gary Robinson on 2/26/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCellView.h"
#import "AppDelegate.h"

#define SETTINGS_CELL_VIEW_TAG 1

@interface SettingsViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingsViewController


- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black-noise"]];
    
//    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.headerImageView];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.titleView = self.titleLabel;
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

- (UILabel*)titleLabel
{
    if(_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor fopLightGreyColor];
        _titleLabel.text = @"FUEL OPERATOR";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont lightFontOfSize:32];
    }
    return _titleLabel;
}

- (UIImageView*)headerImageView
{
    if(_headerImageView == nil)
    {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
        _headerImageView.image = [UIImage imageNamed:@"settings-gradient"];
        _headerImageView.layer.shadowOpacity = 0.25;
        _headerImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _headerImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_headerImageView.bounds].CGPath;
    }
    return _headerImageView;
}

- (UITableView*)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 50*3)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingsCell";
    
    SettingsCellView *cellView = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;// UITableViewCellSelectionStyleGray;
        
        cellView = [[SettingsCellView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.width)];
        cellView.tag = SETTINGS_CELL_VIEW_TAG;
        [cell.contentView addSubview:cellView];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black-noise"]];
    }
    else
    {
        cellView = (SettingsCellView *)[cell.contentView viewWithTag:SETTINGS_CELL_VIEW_TAG];  
    }
    

    if(indexPath.row == 0)
        [cellView setTitle:@"Inspections" withIcon:@"inspections"];
    else if(indexPath.row == 1)
        [cellView setTitle:@"Settings" withIcon:@"settings"];
    else
        [cellView setTitle:@"Logout" withIcon:@"logout"];
            
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row == 2)
    {
        AppDelegate *appD = [[UIApplication sharedApplication] delegate];
        [appD logout:self];
        //[[[UIApplication sharedApplication] delegate] performSelector:@selector(logout:)];
    }
}



@end
