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

@end

@implementation InspectionsListCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.addressLine1Label];
        [self addSubview:self.addressLine2Label];
        [self addSubview:self.circularProgressView];
        [self addSubview:self.progressLabel];
        [self addSubview:self.accessoryView];
    }
    return self;
}

- (UILabel*)nameLabel
{
    if(_nameLabel == nil)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.bounds.size.width - 20, 30)];
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
        _addressLine1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, self.bounds.size.width - 20, 20)];
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
        _addressLine2Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, self.bounds.size.width - 20, 20)];
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

- (void)setStation:(Station *)station
{
    _station = station;
    
    self.nameLabel.text = _station.companyName;
    self.addressLine1Label.text = _station.location.streetAddress;
    self.addressLine2Label.text = [NSString stringWithFormat:@"%@, %@ %@", _station.location.city, _station.location.state, _station.location.zipCode];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    NSInteger percent = (NSInteger)(progress * 100. + 0.5);
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", percent];
    [self.progressLabel sizeToFit];
    self.progressLabel.center = CGPointMake(265, INSPECTIONS_LIST_CELL_HEIGHT/2);
    
    self.circularProgressView.progress = progress;
}

//- (void)setName:(NSString *)name withAddressLine1:(NSString*)line1 andAddressLine2:(NSString*)line2
//{
//    self.nameLabel.text = name;
//    self.addressLine1Label.text = line1;
//    self.addressLine2Label.text = line2;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
