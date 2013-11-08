//
//  SettingsDetailViewController.m
//  FuelOperator
//
//  Created by Gary Robinson on 11/8/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "SettingsDetailViewController.h"

@interface SettingsDetailViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *fakeNavBar;

//@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UITextField *startTextField;
//@property (nonatomic, strong) UIDatePicker *startDatePicker;

//@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, strong) UITextField *endTextField;
//@property (nonatomic, strong) UIDatePicker *endDatePicker;

@property (nonatomic, strong) UILabel *serverURLLabel;
@property (nonatomic, strong) UITextField *serverURLTextField;

@end

@implementation SettingsDetailViewController

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.fakeNavBar];
    
    [self.view addSubview:self.startLabel];
    [self.view addSubview:self.startTextField];
//    [self.view addSubview:self.startDatePicker];
    
    [self.view addSubview:self.endLabel];
    [self.view addSubview:self.endTextField];
//    [self.view addSubview:self.endDatePicker];
    
    [self.view addSubview:self.serverURLLabel];
    [self.view addSubview:self.serverURLTextField];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor fopOffWhiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)fakeNavBar
{
    if(_fakeNavBar == nil)
    {
        _fakeNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 65)];
        
        UIImageView *fakeStatusBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black-noise"]];
        fakeStatusBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
        [_fakeNavBar addSubview:fakeStatusBar];
        
        UIImageView *gradient = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-gradient"]];
        gradient.frame = CGRectMake(0, 20, self.view.bounds.size.width, 45);
        [_fakeNavBar addSubview:gradient];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *cancelImage = [UIImage imageNamed:@"cancel-btn"];
        [cancelButton setImage:cancelImage forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(8, 26, cancelImage.size.width, cancelImage.size.height);
        [cancelButton addTarget:self action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_fakeNavBar addSubview:cancelButton];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(cancelButton.frame.size.width, 23, 200, 45)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldFontOfSize:16];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"Settings";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_fakeNavBar addSubview:titleLabel];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *saveImage = [UIImage imageNamed:@"save-btn"];
        [saveButton setImage:saveImage forState:UIControlStateNormal];
        saveButton.frame = CGRectMake(260, 26, saveImage.size.width, saveImage.size.height);
        [saveButton addTarget:self action:@selector(saveTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_fakeNavBar addSubview:saveButton];
    }
    return _fakeNavBar;
}

- (UILabel *)startLabel
{
    if(_startLabel == nil)
    {
        _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width-20, 30)];
        _startLabel.textColor = [UIColor darkTextColor];
        _startLabel.font = [UIFont regularFontOfSize:16];
        _startLabel.text = @"Start Date";
    }
    return _startLabel;
}

- (UITextField *)startTextField
{
    if(_startTextField == nil)
    {
        _startTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-20, 30)];
        _startTextField.delegate = self;
        _startTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _startTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _startTextField.textColor = [UIColor darkTextColor];
        _startTextField.backgroundColor = [UIColor whiteColor];
    }
    return _startTextField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//- (UIDatePicker *)startDatePicker
//{
//    if(_startDatePicker == nil)
//    {
//        _startDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width - 60, 200)];
//        _startDatePicker.datePickerMode = UIDatePickerModeDate;
//        _startDatePicker.tintColor = [UIColor whiteColor];
//        _startDatePicker.backgroundColor = [UIColor whiteColor];
//    }
//    return _startDatePicker;
//}

- (UILabel *)endLabel
{
    if(_endLabel == nil)
    {
        _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, self.view.frame.size.width-20, 30)];
        _endLabel.textColor = [UIColor darkTextColor];
        _endLabel.font = [UIFont regularFontOfSize:16];
        _endLabel.text = @"End Date";
    }
    return _endLabel;
}

- (UITextField *)endTextField
{
    if(_endTextField == nil)
    {
        _endTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 160, self.view.frame.size.width-20, 30)];
        _endTextField.delegate = self;
        _endTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _endTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _endTextField.textColor = [UIColor darkTextColor];
        _endTextField.backgroundColor = [UIColor whiteColor];
    }
    return _endTextField;
}


//- (UIDatePicker *)endDatePicker
//{
//    if(_endDatePicker == nil)
//    {
//        _endDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 260, self.view.frame.size.width - 60, 200)];
//        _endDatePicker.datePickerMode = UIDatePickerModeDate;
//        _endDatePicker.tintColor = [UIColor whiteColor];
//        _endDatePicker.backgroundColor = [UIColor whiteColor];
//    }
//    return _endDatePicker;
//}

- (UILabel *)serverURLLabel
{
    if(_serverURLLabel == nil)
    {
        _serverURLLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, self.view.frame.size.width-20, 30)];
        _serverURLLabel.textColor = [UIColor darkTextColor];
        _serverURLLabel.font = [UIFont regularFontOfSize:16];
        _serverURLLabel.text = @"Server URL";
        [_serverURLLabel sizeToFit];
    }
    return _serverURLLabel;
}

- (UITextField *)serverURLTextField
{
    if(_serverURLTextField == nil)
    {
        _serverURLTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 220, self.view.frame.size.width-20, 30)];
        _serverURLTextField.delegate = self;
        _serverURLTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _serverURLTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _serverURLTextField.textColor = [UIColor darkTextColor];
        _serverURLTextField.backgroundColor = [UIColor whiteColor];
    }
    return _serverURLTextField;
}

@end
