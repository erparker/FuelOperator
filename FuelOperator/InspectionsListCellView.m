//
//  InspectionsListCellView.m
//  FuelOperator
//
//  Created by Gary Robinson on 3/15/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "InspectionsListCellView.h"
#import "AccessoryView.h"
#import "CircularProgressView.h"

@interface InspectionsListCellView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLine1Label;
@property (nonatomic, strong) UILabel *addressLine2Label;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) CircularProgressView *circularProgressView;
@property (nonatomic, strong) AccessoryView *accessoryView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIView *acceptedView;

//map version
@property (nonatomic) BOOL mapStyle;
@property (nonatomic, strong) UIView *titleBackground;

@end

@implementation InspectionsListCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.mapStyle = NO;
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.addressLine1Label];
        [self addSubview:self.addressLine2Label];
        [self addSubview:self.circularProgressView];
        [self addSubview:self.progressLabel];
        [self addSubview:self.accessoryView];
        [self addSubview:self.submitButton];
        [self addSubview:self.acceptedView];
    }
    return self;
}

- (UILabel*)nameLabel
{
    if(_nameLabel == nil)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.bounds.size.width - 100, 30)];
        _nameLabel.font = [UIFont mediumFontOfSize:18];
        _nameLabel.textColor = [UIColor fopDarkText];
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nameLabel;
}

- (UILabel*)addressLine1Label
{
    if(_addressLine1Label == nil)
    {
        _addressLine1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, self.bounds.size.width - 100, 20)];
        _addressLine1Label.font = [UIFont regularFontOfSize:16];
        _addressLine1Label.textColor = [UIColor fopDarkText];
        _addressLine1Label.backgroundColor = [UIColor clearColor];
    }
    return _addressLine1Label;
}

- (UILabel*)addressLine2Label
{
    if(_addressLine2Label == nil)
    {
        _addressLine2Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, self.bounds.size.width - 100, 20)];
        _addressLine2Label.font = [UIFont regularFontOfSize:16];
        _addressLine2Label.textColor = [UIColor fopDarkText];
        _addressLine2Label.backgroundColor = [UIColor clearColor];
    }
    return _addressLine2Label;
}

- (UILabel *)progressLabel
{
    if(_progressLabel == nil)
    {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 30, 30, 20)];
        _progressLabel.font = [UIFont mediumFontOfSize:14];
        _progressLabel.textColor = [UIColor fopDarkText];
        _progressLabel.backgroundColor = [UIColor clearColor];
    }
    return _progressLabel;
}

- (CircularProgressView *)circularProgressView
{
    if(_circularProgressView == nil)
    {
        _circularProgressView = [[CircularProgressView alloc] initWithFrame:CGRectMake(240, 15, 50, 50)];
    }
    return _circularProgressView;
}

- (AccessoryView*)accessoryView
{
    if(_accessoryView == nil)
    {
        _accessoryView = [[AccessoryView alloc] initWithFrame:CGRectMake(320-20, INSPECTIONS_LIST_CELL_HEIGHT/2 - 20/2 + 2, 20, 20)];
    }
    return _accessoryView;
}

- (UIView *)acceptedView
{
    if(_acceptedView == nil)
    {
        _acceptedView = [[UIView alloc] initWithFrame:CGRectMake(210, 0, 100, INSPECTIONS_LIST_CELL_HEIGHT)];
        _acceptedView.backgroundColor = [UIColor clearColor];
        
        UIImage *image = [UIImage imageNamed:@"accepted"];
        UIImageView *acceptedImageView = [[UIImageView alloc] initWithImage:image];
        acceptedImageView.center = CGPointMake(image.size.width/2, INSPECTIONS_LIST_CELL_HEIGHT/2 - 3);
        [_acceptedView addSubview:acceptedImageView];
        
        UILabel *acceptedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 80, 30)];
        [acceptedLabel setTextColor:[UIColor fopDarkText]];
        [acceptedLabel setFont:[UIFont regularFontOfSize:16]];
        acceptedLabel.backgroundColor = [UIColor clearColor];
        acceptedLabel.text = @"Accepted";
        [acceptedLabel sizeToFit];
        acceptedLabel.center = CGPointMake(50, INSPECTIONS_LIST_CELL_HEIGHT/2);
        [_acceptedView addSubview:acceptedLabel];
    }
    return _acceptedView;
}

- (UIButton *)submitButton
{
    if(_submitButton == nil)
    {
        _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _submitButton.frame = CGRectMake(230, 20, 60, 30);
        _submitButton.layer.cornerRadius = 4;
        [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        _submitButton.backgroundColor = [UIColor blackColor];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (void)submitTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inspectionSubmitted:) name:@"inspectionSubmitted" object:nil];
    [[OnlineService sharedService] submitInspection:self.inspection];
}

- (void)inspectionSubmitted:(id)sender
{
    [self setProgress:self.progress];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setInspection:(Inspection *)inspection
{
    _inspection = inspection;
    
    self.nameLabel.text = _inspection.facility.storeCode;
    self.addressLine1Label.text = _inspection.facility.address1;
    self.addressLine2Label.text = [NSString stringWithFormat:@"%@, %@ %@", _inspection.facility.city, _inspection.facility.state, _inspection.facility.zip];
    
    [self setProgress:[inspection.progress floatValue]];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    if([self.inspection.submitted boolValue])
    {
        self.acceptedView.hidden = NO;
        
        self.circularProgressView.hidden = YES;
        self.progressLabel.hidden = YES;
        self.submitButton.hidden = YES;
    }
    else
    {
        self.acceptedView.hidden = YES;
        
        NSInteger percent = (NSInteger)(progress * 100. + 0.5);
        self.progressLabel.text = [NSString stringWithFormat:@"%d%%", percent];
        [self.progressLabel sizeToFit];
        if(!self.mapStyle)
            self.progressLabel.center = CGPointMake(265, INSPECTIONS_LIST_CELL_HEIGHT/2);
        else
            self.progressLabel.center = CGPointMake(235, 55);
        
        self.circularProgressView.progress = progress;
        
        BOOL hideProgress = NO;
        if(progress <= 0 || progress >= 1.0)
            hideProgress = YES;
        
        self.circularProgressView.hidden = hideProgress;
        self.progressLabel.hidden = hideProgress;
        
        if(progress >= 1.0)
            self.submitButton.hidden = NO;
        else
            self.submitButton.hidden = YES;
    }
}

- (void)applyMapStyle
{
    self.mapStyle = YES;
    
    [self addSubview:self.titleBackground];
    [self sendSubviewToBack:self.titleBackground];
    
    //?? need a gas icon
    UIImage *gasImage = [UIImage imageNamed:@"gas-icon"];
    UIImageView *icon = [[UIImageView alloc] initWithImage:gasImage];
    icon.frame = CGRectMake(10, 10, gasImage.size.width, gasImage.size.height);
    [self addSubview:icon];
    
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.frame = CGRectMake(25, 7, self.bounds.size.width - 20, 20);
    
    self.circularProgressView.frame = CGRectMake(215, 35, 40, 40);
    self.progressLabel.font = [UIFont mediumFontOfSize:12];
    
    self.accessoryView.frame = CGRectMake(265, 52, 20, 20);
}

- (UIView *)titleBackground
{
    if(_titleBackground == nil)
    {
        _titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
        _titleBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black-noise"]];
    }
    return _titleBackground;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
