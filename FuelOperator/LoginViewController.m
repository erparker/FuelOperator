//
//  LoginViewController.m
//  FuelOperator
//
//  Created by Gary Robinson on 3/13/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "LoginViewController.h"
#import "InnerShadowView.h"
#import "AppDelegate.h"

@interface LoginViewController ()  <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *appTitle;
@property (nonatomic, strong) InnerShadowView *loginFormView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation LoginViewController

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
    
    [self.view addSubview:self.appTitle];
    [self.view addSubview:self.loginFormView];
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
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

- (UILabel*)appTitle
{
    if(_appTitle == nil)
    {
        _appTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _appTitle.backgroundColor = [UIColor clearColor];
        _appTitle.text = @"FUEL OPERATOR";
        _appTitle.font = [UIFont thinFontOfSize:36];
        _appTitle.textColor = [UIColor fopLightGreyColor];
        _appTitle.numberOfLines = 1;
        [_appTitle sizeToFit];
        _appTitle.center = CGPointMake(self.view.frame.size.width/2., 80);
    }
    return _appTitle;
}

- (InnerShadowView*)loginFormView
{
    if(_loginFormView == nil)
    {
        _loginFormView = [[InnerShadowView alloc] initWithFrame:CGRectMake(39, 120, 242, 108)];
        _loginFormView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _loginFormView.frame.size.height/2., _loginFormView.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor fopDarkText];
        [_loginFormView addSubview:lineView];
    }
    return _loginFormView;
}

- (UITextField*)usernameTextField
{
    if(_usernameTextField == nil)
    {
        _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 137, 220, 40)];
        _usernameTextField.delegate = self;
        //_usernameTextField.placeholder = @"User Name";
        _usernameTextField.font = [UIFont regularFontOfSize:24];
        _usernameTextField.textColor = [UIColor darkTextColor];
    }
    return _usernameTextField;
}

- (UITextField*)passwordTextField
{
    if(_passwordTextField == nil)
    {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 190, 220, 40)];
        _passwordTextField.delegate = self;
        //_passwordTextField.placeholder = @"Password";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.font = [UIFont regularFontOfSize:24];
        _passwordTextField.textColor = [UIColor darkTextColor];
    }
    return _passwordTextField;
}

- (UIButton*)loginButton
{
    if(_loginButton == nil)
    {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *loginImage = [UIImage imageNamed:@"btn-login"];
        [_loginButton setImage:loginImage forState:UIControlStateNormal];
        _loginButton.frame = CGRectMake(0, 0, loginImage.size.width, loginImage.size.height);
        _loginButton.center = CGPointMake(self.view.bounds.size.width/2., 284/*self.view.bounds.size.height/2.*/);
        [_loginButton addTarget:self action:@selector(loginCompleted:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];
    return YES;
}

-(void)loginCompleted:(id)sender
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    //NSLog(@"username= %@, password= %@\n", self.usernameTextField.text, self.passwordTextField.text);
    AppDelegate *appD = [[UIApplication sharedApplication] delegate];
    [appD loginCompleted:self];
}

@end
