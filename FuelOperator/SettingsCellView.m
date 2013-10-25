//
//  SettingsCellView.m
//  FuelOperator
//
//  Created by Gary Robinson on 3/12/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "SettingsCellView.h"

@interface SettingsCellView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *separatorView;

@end

@implementation SettingsCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.titleLabel];
        [self addSubview:self.iconView];
        [self addSubview:self.separatorView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UILabel*)titleLabel
{
    if(_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 13, 320-50, 30)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont lightFontOfSize:24];
        _titleLabel.textColor = [UIColor fopLightGreyColor];
    }
    return _titleLabel;
}

- (UIImageView*)iconView
{
    if(_iconView == nil)
    {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 24, 24)];
    }
    return _iconView;
}

- (UIImageView*)separatorView
{
    if(_separatorView == nil)
    {
        _separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 48, 320, 2)];
        _separatorView.image = [UIImage imageNamed:@"settings-separator"];
    }
    return _separatorView;
}

- (void)setTitle:(NSString*)title withIcon:(NSString*)imageName
{
    self.titleLabel.text = title;
    self.iconView.image = [UIImage imageNamed:imageName];
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
