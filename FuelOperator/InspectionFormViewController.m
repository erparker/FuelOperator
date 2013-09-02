//
//  InspectionFormViewController.m
//  FuelOperator
//
//  Created by Gary Robinson on 3/16/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "InspectionFormViewController.h"
#import "InspectionsFormCell.h"
#import "CommentPhotoViewController.h"
#import "FormCategoryView.h"

#define HEADER_HEIGHT 25
#define BUTTON_HEIGHT 47
#define PROGRESS_HEIGHT 25
#define NAV_BAR_HEIGHT 40


@interface InspectionFormViewController () <UITableViewDataSource, UITableViewDelegate, FormCategoryDelegate>

@property (nonatomic, strong) UILabel *navigationLabel;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UISlider *progressSlider;

@property (nonatomic, strong) FormCategoryView *facilityView;
@property (nonatomic, strong) UIButton *facilityButton;

@property (nonatomic, strong) FormCategoryView *tanksView;
@property (nonatomic, strong) UIButton *tanksButton;

@property (nonatomic, strong) FormCategoryView *dispensersView;
@property (nonatomic, strong) UIButton *dispensersButton;

@end

@implementation InspectionFormViewController

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.facilityView];
    [self.view addSubview:self.facilityButton];
    [self.view addSubview:self.tanksView];
    [self.view addSubview:self.tanksButton];
    [self.view addSubview:self.dispensersView];
    [self.view addSubview:self.dispensersButton];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.titleView = self.navigationLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.sendButton];
        
    [self facilityButtonTapped:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateProgressView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInspection:(Inspection *)inspection
{
    _inspection = inspection;
    
    NSString *formTitle = [NSString stringWithFormat:@"%@ - %@, %@", inspection.station.companyName, inspection.station.location.city, inspection.station.location.state];
    self.navigationLabel.text = formTitle;
}

- (UILabel*)navigationLabel
{
    if(_navigationLabel == nil)
    {
        _navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _navigationLabel.backgroundColor = [UIColor clearColor];
        _navigationLabel.textColor = [UIColor whiteColor];
        _navigationLabel.font = [UIFont regularFontOfSize:20];
        _navigationLabel.text = @"Sinclair - Sandy, UT";
        [_navigationLabel sizeToFit];
    }
    return _navigationLabel;
}

- (UIButton*)sendButton
{
    if(_sendButton == nil)
    {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
        _sendButton.frame = CGRectMake(0, 0, 50, 30);
        [_sendButton addTarget:self action:@selector(sendInspection:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (void)sendInspection:(UIButton *)sender
{
    [[OnlineService sharedService] sendInspection:self.inspection];
}

- (UIView*)progressView
{
    if(_progressView == nil)
    {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, PROGRESS_HEIGHT)];
        _progressView.backgroundColor = [UIColor fopProgressBackgroundColor];
        [_progressView addSubview:self.progressLabel];
        [_progressView addSubview:self.progressSlider];
    }
    return _progressView;
}

- (UILabel*)progressLabel
{
    if(_progressLabel == nil)
    {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 15)];
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.font = [UIFont boldFontOfSize:12];
        _progressLabel.text = @"0% Complete";
    }
    return _progressLabel;
}

- (UISlider*)progressSlider
{
    if(_progressSlider == nil)
    {
        _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(97, 0, 215, 9)];
        _progressSlider.value = 0.;
        
        UIImage* minImage = [UIImage imageNamed:@"progressSliderYellow"];
        minImage = [minImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        UIImage* maxImage = [UIImage imageNamed:@"progressSliderBlack"];
        maxImage = [maxImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        
        [_progressSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
        [_progressSlider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
        [_progressSlider setThumbImage:[[UIImage alloc] init] forState:UIControlStateHighlighted];
        [_progressSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    }
    return _progressSlider;
}

- (void)updateProgressView
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    NSArray *allAnswers = [self.inspection.formAnswers allObjects];
    NSInteger numAnswered = 0;
    for(FormAnswer *a in allAnswers)
    {
        if([a isAnswered])
            numAnswered++;
    }
    float value = (float)(numAnswered) / (float)(allAnswers.count);
    self.inspection.progress = [NSNumber numberWithFloat:value];
    self.progressSlider.value = [self.inspection.progress floatValue];
    NSInteger percent = (NSInteger)(self.progressSlider.value * 100. + 0.5);
    self.progressLabel.text = [NSString stringWithFormat:@"%d%% Complete", percent];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    //reload visible table view
    if(!self.facilityView.hidden)
        [self.facilityView.tableView reloadData];
    else if(!self.tanksView.hidden)
        [self.tanksView.tableView reloadData];
    else if(!self.dispensersView.hidden)
        [self.dispensersView.tableView reloadData];
}

- (void)editCommentPhotosForAnswer:(FormAnswer *)formAnswer
{
    CommentPhotoViewController *commentPhotoVC = [[CommentPhotoViewController alloc] initWithAnswer:formAnswer];
    commentPhotoVC.formCategoryDelegate = self;
    [self presentViewController:commentPhotoVC animated:YES completion:nil];
}

- (FormCategoryView *)facilityView
{
    if(_facilityView == nil)
    {
        _facilityView = [[FormCategoryView alloc] initWithFrame:CGRectMake(0, PROGRESS_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - PROGRESS_HEIGHT - BUTTON_HEIGHT - NAV_BAR_HEIGHT)];
        
        _facilityView.formCategoryDelegate = self;
        _facilityView.inspection = self.inspection;
        NSArray *allQuestions = [self.inspection.formQuestions allObjects];
        NSArray *facilityQuestions = [allQuestions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@", @"Facilities"]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedQuestions = [facilityQuestions sortedArrayUsingDescriptors:sortDescriptors];
        _facilityView.formQuestions = sortedQuestions;
    }
    return _facilityView;
}

- (FormCategoryView *)tanksView
{
    if(_tanksView == nil)
    {
        _tanksView = [[FormCategoryView alloc] initWithFrame:CGRectMake(0, PROGRESS_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - PROGRESS_HEIGHT - BUTTON_HEIGHT - NAV_BAR_HEIGHT)];
        
        _tanksView.formCategoryDelegate = self;
        _tanksView.inspection = self.inspection;
        NSArray *allQuestions = [self.inspection.formQuestions allObjects];
        NSArray *facilityQuestions = [allQuestions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@", @"Tanks"]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedQuestions = [facilityQuestions sortedArrayUsingDescriptors:sortDescriptors];
        _tanksView.formQuestions = sortedQuestions;
    }
    return _tanksView;
}

- (FormCategoryView *)dispensersView
{
    if(_dispensersView == nil)
    {
        _dispensersView = [[FormCategoryView alloc] initWithFrame:CGRectMake(0, PROGRESS_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - PROGRESS_HEIGHT - BUTTON_HEIGHT - NAV_BAR_HEIGHT)];
        
        _dispensersView.formCategoryDelegate = self;
        _dispensersView.inspection = self.inspection;
        NSArray *allQuestions = [self.inspection.formQuestions allObjects];
        NSArray *facilityQuestions = [allQuestions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@", @"Dispensers"]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedQuestions = [facilityQuestions sortedArrayUsingDescriptors:sortDescriptors];
        _dispensersView.formQuestions = sortedQuestions;
    }
    return _dispensersView;
}




- (UIButton*)facilityButton
{
    if(_facilityButton == nil)
    {
        _facilityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _facilityButton.frame = CGRectMake(0, self.view.bounds.size.height - BUTTON_HEIGHT - NAV_BAR_HEIGHT, self.view.bounds.size.width/3., BUTTON_HEIGHT);
        [_facilityButton setImage:[UIImage imageNamed:@"btn-facility-normal.png"] forState:UIControlStateNormal];
        [_facilityButton setImage:[UIImage imageNamed:@"btn-facility-selected.png"] forState:UIControlStateSelected];
        [_facilityButton setBackgroundImage:[UIImage imageNamed:@"btn-background-normal"] forState:UIControlStateNormal];
        [_facilityButton setBackgroundImage:[UIImage imageNamed:@"btn-background-selected"] forState:UIControlStateSelected];
        [_facilityButton addTarget:self action:@selector(facilityButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _facilityButton;
}

- (void)facilityButtonTapped:(id)sender
{
    self.facilityView.hidden = NO;
    self.facilityButton.selected = YES;
    self.tanksView.hidden = YES;
    self.tanksButton.selected = NO;
    self.dispensersView.hidden = YES;
    self.dispensersButton.selected = NO;
}

- (UIButton*)tanksButton
{
    if(_tanksButton == nil)
    {
        _tanksButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tanksButton.frame = CGRectMake(self.view.bounds.size.width/3., self.view.bounds.size.height - BUTTON_HEIGHT - NAV_BAR_HEIGHT, self.view.bounds.size.width/3., BUTTON_HEIGHT);
        [_tanksButton setImage:[UIImage imageNamed:@"btn-tanks-normal"] forState:UIControlStateNormal];
        [_tanksButton setImage:[UIImage imageNamed:@"btn-tanks-selected"] forState:UIControlStateSelected];
        [_tanksButton setBackgroundImage:[UIImage imageNamed:@"btn-background-normal"] forState:UIControlStateNormal];
        [_tanksButton setBackgroundImage:[UIImage imageNamed:@"btn-background-selected"] forState:UIControlStateSelected];
        [_tanksButton addTarget:self action:@selector(tanksButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tanksButton;
}

- (void)tanksButtonTapped:(id)sender
{
    self.facilityView.hidden = YES;
    self.facilityButton.selected = NO;
    self.tanksView.hidden = NO;
    self.tanksButton.selected = YES;
    self.dispensersView.hidden = YES;
    self.dispensersButton.selected = NO;
}

- (UIButton*)dispensersButton
{
    if(_dispensersButton == nil)
    {
        _dispensersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dispensersButton.frame = CGRectMake(self.view.bounds.size.width * 2./3., self.view.bounds.size.height - BUTTON_HEIGHT - NAV_BAR_HEIGHT, self.view.bounds.size.width/3., BUTTON_HEIGHT);
        [_dispensersButton setImage:[UIImage imageNamed:@"btn-dispensers-normal"] forState:UIControlStateNormal];
        [_dispensersButton setImage:[UIImage imageNamed:@"btn-dispensers-selected"] forState:UIControlStateSelected];
        [_dispensersButton setBackgroundImage:[UIImage imageNamed:@"btn-background-normal"] forState:UIControlStateNormal];
        [_dispensersButton setBackgroundImage:[UIImage imageNamed:@"btn-background-selected"] forState:UIControlStateSelected];
        [_dispensersButton addTarget:self action:@selector(dispensersButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dispensersButton;
}

- (void)dispensersButtonTapped:(id)sender
{
    self.facilityView.hidden = YES;
    self.facilityButton.selected = NO;
    self.tanksView.hidden = YES;
    self.tanksButton.selected = NO;
    self.dispensersView.hidden = NO;
    self.dispensersButton.selected = YES;
}

@end
