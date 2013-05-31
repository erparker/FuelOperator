//
//  UpcomingInspectionsCellView.m
//  FuelOperator
//
//  Created by Gary Robinson on 3/13/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "UpcomingInspectionsCellView.h"
#import "AccessoryView.h"

@interface UpcomingInspectionsCellView ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *numInspectionsLabel;
@property (nonatomic, strong) AccessoryView *accessoryView;

@end

@implementation UpcomingInspectionsCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.dayLabel];
        [self addSubview:self.numInspectionsLabel];
        [self addSubview:self.accessoryView];
    }
    return self;
}

- (UILabel*)dayLabel
{
    if(_dayLabel == nil)
    {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320-45, UPCOMING_INSPECTIONS_CELL_HEIGHT)];
        _dayLabel.font = [UIFont thinFontOfSize:36];
        _dayLabel.textColor = [UIColor fopRegularText];
        _dayLabel.backgroundColor = [UIColor clearColor];
    }
    return _dayLabel;
}

- (UILabel*)numInspectionsLabel
{
    if(_numInspectionsLabel == nil)
    {
        _numInspectionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-65, 0, 40, UPCOMING_INSPECTIONS_CELL_HEIGHT)];
        _numInspectionsLabel.font = [UIFont lightFontOfSize:20];
        _numInspectionsLabel.textColor = [UIColor fopRegularText];
        _numInspectionsLabel.backgroundColor = [UIColor clearColor];
        _numInspectionsLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numInspectionsLabel;
}

- (AccessoryView*)accessoryView
{
    if(_accessoryView == nil)
    {
        _accessoryView = [[AccessoryView alloc] initWithFrame:CGRectMake(320-20, UPCOMING_INSPECTIONS_CELL_HEIGHT/2 - 20/2 + 2, 20, 20)];
    }
    return _accessoryView;
}

- (void)setDayTitle:(NSString*)title withNumInspections:(NSUInteger)numInspections
{
    self.dayLabel.text = title;
    self.numInspectionsLabel.text = [NSString stringWithFormat:@"%d", numInspections];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
}


@end
