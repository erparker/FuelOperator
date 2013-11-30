//
//  SignatureViewController.m
//  FuelOperator
//
//  Created by Gary Robinson on 11/30/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "SignatureViewController.h"
#import "SignatureView.h"

@interface SignatureViewController ()

@property (nonatomic, strong) UIView *fakeNavBar;
@property (nonatomic, strong) UILabel *certifyLabel;
@property (nonatomic, strong) SignatureView *signatureView;

@end

@implementation SignatureViewController


- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor fopOffWhiteColor];
    
    [self.view addSubview:self.fakeNavBar];
    [self.view addSubview:self.certifyLabel];
    [self.view addSubview:self.signatureView];
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
        titleLabel.text = @"Certify Inspection";
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

- (void)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveTapped:(id)sender
{
    UIImage *image = [self snapshotImage:self.signatureView];
    
    //?? save an image of the signature and submit that as well
    [[OnlineService sharedService] submitInspection:self.inspection withSignatureImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UILabel *)certifyLabel
{
    if(_certifyLabel == nil)
    {
        _certifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.bounds.size.width-20, 100)];
        _certifyLabel.font = [UIFont boldFontOfSize:16];
        _certifyLabel.textColor = [UIColor fopDarkText];
        _certifyLabel.numberOfLines = 0;
//        _certifyLabel.textAlignment = NSTextAlignmentCenter;
        _certifyLabel.text = @"I certify under penalty of law that I have personally examined this facility and that all information submitted in this inspection including attached documents, photos, and comments are complete and accurate.";
    }
    return _certifyLabel;
}

- (SignatureView *)signatureView
{
    if(_signatureView == nil)
    {
        _signatureView = [[SignatureView alloc] initWithFrame:CGRectMake(10, 170, self.view.bounds.size.width-20, /*self.view.bounds.size.height -*/ 200)];
    }
    return _signatureView;
}

- (UIImage *)snapshotImage:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}


@end
