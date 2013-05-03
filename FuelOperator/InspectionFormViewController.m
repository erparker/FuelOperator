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

#define HEADER_HEIGHT 25
#define BUTTON_HEIGHT 47
#define PROGRESS_HEIGHT 25
#define NAV_BAR_HEIGHT 40

#define FACILITY_TAB_NAME @"facility"
#define TANKS_TAB_NAME @"tanks"
#define DISPENSERS_TAB_NAME @"dispensers"

@interface InspectionFormViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *navigationLabel;

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UISlider *progressSlider;

@property (nonatomic, strong) UITableView *facilityTableView;
@property (nonatomic, strong) UIButton *facilityButton;
@property (nonatomic, strong) NSMutableArray *facilityQuestionsState;
@property (nonatomic, strong) NSMutableArray *facilityQuestions;
@property (nonatomic, strong) NSMutableArray *facilityQuestionsCommentState;

@property (nonatomic, strong) UITableView *tanksTableView;
@property (nonatomic, strong) UIButton *tanksButton;
@property (nonatomic, strong) NSMutableArray *tanksQuestionsState;
@property (nonatomic, strong) NSMutableArray *tanksQuestions;
@property (nonatomic, strong) NSMutableArray *tanksQuestionsCommentState;

@property (nonatomic, strong) UITableView *dispensersTableView;
@property (nonatomic, strong) UIButton *dispensersButton;
@property (nonatomic, strong) NSMutableArray *dispensersQuestionsState;
@property (nonatomic, strong) NSMutableArray *dispensersQuestions;
@property (nonatomic, strong) NSMutableArray *dispensersQuestionsCommentState;

@end

@implementation InspectionFormViewController

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.facilityTableView];
    [self.view addSubview:self.facilityButton];
    [self.view addSubview:self.tanksTableView];
    [self.view addSubview:self.tanksButton];
    [self.view addSubview:self.dispensersTableView];
    [self.view addSubview:self.dispensersButton];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.titleView = self.navigationLabel;
    
    self.facilityQuestionsState = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    
    self.facilityQuestionsCommentState = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    
    self.facilityQuestions = [[NSMutableArray alloc] initWithObjects:@"Is emergency response plan present?", @"UST Permit present and not expired?", @"Are all operator records present?", @"ATG working properly and not in alarm?", @"Are vents and vent caps undamaged?", @"Are fire extinguishers located within 100' of dispensers and not expired?", @"Is ESO located within 100' of dispensers and working properly?", @"Have all employees passed Class C Operator training and have proof?", nil];
    
    self.tanksQuestionsState = [[NSMutableArray alloc] initWithArray:self.facilityQuestionsState copyItems:YES];
    self.tanksQuestionsCommentState = [[NSMutableArray alloc] initWithArray:self.facilityQuestionsCommentState copyItems:YES];
    self.tanksQuestions = [[NSMutableArray alloc] initWithArray:self.facilityQuestions copyItems:YES];
    
    self.dispensersQuestionsState = [[NSMutableArray alloc] initWithArray:self.facilityQuestionsState copyItems:YES];
    self.dispensersQuestionsCommentState = [[NSMutableArray alloc] initWithArray:self.facilityQuestionsCommentState copyItems:YES];
    self.dispensersQuestions = [[NSMutableArray alloc] initWithArray:self.facilityQuestions copyItems:YES];
    
    [self facilityButtonTapped:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.facilityTableView.hidden)
        [self.facilityTableView reloadData];
    else if(!self.tanksTableView.hidden)
        [self.tanksTableView reloadData];
    else if(!self.dispensersTableView.hidden)
        [self.dispensersTableView reloadData];
    
    [self updateProgress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)setFormTitle:(NSString *)formTitle
{
    _formTitle = formTitle;
    self.navigationLabel.text = _formTitle;
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

- (UITableView*)facilityTableView
{
    if(_facilityTableView == nil)
    {
        _facilityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, PROGRESS_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - PROGRESS_HEIGHT - BUTTON_HEIGHT - NAV_BAR_HEIGHT)];
        _facilityTableView.dataSource = self;
        _facilityTableView.delegate = self;
        _facilityTableView.backgroundColor = [UIColor fopOffWhiteColor];
        _facilityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _facilityTableView;
}

- (UITableView*)tanksTableView
{
    if(_tanksTableView == nil)
    {
        _tanksTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, PROGRESS_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - PROGRESS_HEIGHT - BUTTON_HEIGHT - NAV_BAR_HEIGHT)];
        _tanksTableView.dataSource = self;
        _tanksTableView.delegate = self;
        _tanksTableView.backgroundColor = [UIColor fopOffWhiteColor];
        _tanksTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tanksTableView;
}

- (UITableView*)dispensersTableView
{
    if(_dispensersTableView == nil)
    {
        _dispensersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, PROGRESS_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - PROGRESS_HEIGHT - BUTTON_HEIGHT - NAV_BAR_HEIGHT)];
        _dispensersTableView.dataSource = self;
        _dispensersTableView.delegate = self;
        _dispensersTableView.backgroundColor = [UIColor fopOffWhiteColor];
        _dispensersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _dispensersTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
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
    headerLabel.text = @"Category 1";
    [headerLabel sizeToFit];
    headerLabel.frame = CGRectMake(5, 5, tableView.bounds.size.width - 5, headerLabel.frame.size.height);
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL bHasComment = NO;
    
    NSString *tabName = nil;
    if(tableView == self.facilityTableView)
        tabName = FACILITY_TAB_NAME;
    else if(tableView == self.tanksTableView)
        tabName = TANKS_TAB_NAME;
    else if(tableView == self.dispensersTableView)
        tabName = DISPENSERS_TAB_NAME;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *commentFormat = [NSString stringWithFormat:@"%@_comment_%d.txt", tabName, indexPath.row];
    NSString *commentPath = [documentsDirectory stringByAppendingPathComponent:commentFormat];
    NSString *comment = [[NSString alloc]initWithContentsOfFile:commentPath usedEncoding:nil error:nil];
    if(comment)
    {
        bHasComment = YES;
    }
    else
    {
        NSString* path1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_image_%d_%d.png", tabName, indexPath.row, 1]];
        UIImage* image1 = [UIImage imageWithContentsOfFile:path1];
        if(image1)
            bHasComment = YES;
    }
    
    NSNumber* state = nil;
    NSString* question = nil;
    NSNumber* hasComment = nil;
    if(tableView == self.facilityTableView)
    {
        [self.facilityQuestionsCommentState setObject:[NSNumber numberWithBool:bHasComment] atIndexedSubscript:indexPath.row];
        state = [self.facilityQuestionsState objectAtIndex:indexPath.row];
        question = [self.facilityQuestions objectAtIndex:indexPath.row];
        hasComment = [self.facilityQuestionsCommentState objectAtIndex:indexPath.row];
    }
    else if(tableView == self.tanksTableView)
    {
        [self.tanksQuestionsCommentState setObject:[NSNumber numberWithBool:bHasComment] atIndexedSubscript:indexPath.row];
        state = [self.tanksQuestionsState objectAtIndex:indexPath.row];
        question = [self.tanksQuestions objectAtIndex:indexPath.row];
        hasComment = [self.tanksQuestionsCommentState objectAtIndex:indexPath.row];
    }
    else if(tableView == self.dispensersTableView)
    {
        [self.dispensersQuestionsCommentState setObject:[NSNumber numberWithBool:bHasComment] atIndexedSubscript:indexPath.row];
        state = [self.dispensersQuestionsState objectAtIndex:indexPath.row];
        question = [self.dispensersQuestions objectAtIndex:indexPath.row];
        hasComment = [self.dispensersQuestionsCommentState objectAtIndex:indexPath.row];
    }
    
    CGFloat height = [InspectionsFormCell getCellHeightForQuestion:question withState:[state integerValue] withComment:[hasComment integerValue]];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"inspectionsFormCell";
    
    InspectionsFormCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[InspectionsFormCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withTarget:self];
    
    if(tableView == self.facilityTableView)
    {
        NSNumber *curState = [self.facilityQuestionsState objectAtIndex:indexPath.row];
        cell.state = [curState integerValue];
        cell.question = [self.facilityQuestions objectAtIndex:indexPath.row];
        cell.commentState = [[self.facilityQuestionsCommentState objectAtIndex:indexPath.row] integerValue];
    }
    else if(tableView == self.tanksTableView)
    {
        NSNumber *curState = [self.tanksQuestionsState objectAtIndex:indexPath.row];
        cell.state = [curState integerValue];
        cell.question = [self.tanksQuestions objectAtIndex:indexPath.row];
        cell.commentState = [[self.tanksQuestionsCommentState objectAtIndex:indexPath.row] integerValue];
    }
    else if(tableView == self.dispensersTableView)
    {
        NSNumber *curState = [self.dispensersQuestionsState objectAtIndex:indexPath.row];
        cell.state = [curState integerValue];
        cell.question = [self.dispensersQuestions objectAtIndex:indexPath.row];
        cell.commentState = [[self.dispensersQuestionsCommentState objectAtIndex:indexPath.row] integerValue];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentPhotoViewController *commentPhotoVC = [[CommentPhotoViewController alloc] init];
    
    if(tableView == self.facilityTableView)
    {
        commentPhotoVC.question = [self.facilityQuestions objectAtIndex:indexPath.row];
        commentPhotoVC.tabName = FACILITY_TAB_NAME;
    }
    else if(tableView == self.tanksTableView)
    {
        commentPhotoVC.question = [self.tanksQuestions objectAtIndex:indexPath.row];
        commentPhotoVC.tabName = @"tanks";
    }
    else if(tableView == self.dispensersTableView)
    {
        commentPhotoVC.question = [self.dispensersQuestions objectAtIndex:indexPath.row];
        commentPhotoVC.tabName = @"dispensers";
    }
    
    commentPhotoVC.row = indexPath.row;
    [self presentViewController:commentPhotoVC animated:YES completion:nil];
}

- (void)didSelectAccessory:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    
    if(!self.facilityTableView.hidden)
    {
        CGPoint currentTouchPosition = [touch locationInView:self.facilityTableView];
        NSIndexPath *indexPath = [self.facilityTableView indexPathForRowAtPoint: currentTouchPosition];
        
        //update the question state according to the tap
        NSInteger state = [[self.facilityQuestionsState objectAtIndex:indexPath.row] integerValue] + 1;
        if(state > 2)
            state = 0;
        [self.facilityQuestionsState setObject:[NSNumber numberWithInt:state] atIndexedSubscript:indexPath.row];
        
        [self updateProgress];
        [self.facilityTableView reloadData];
    }
    else if(!self.tanksTableView.hidden)
    {
        CGPoint currentTouchPosition = [touch locationInView:self.tanksTableView];
        NSIndexPath *indexPath = [self.tanksTableView indexPathForRowAtPoint: currentTouchPosition];
        
        //update the question state according to the tap
        NSInteger state = [[self.tanksQuestionsState objectAtIndex:indexPath.row] integerValue] + 1;
        if(state > 2)
            state = 0;
        [self.tanksQuestionsState setObject:[NSNumber numberWithInt:state] atIndexedSubscript:indexPath.row];
        
        [self updateProgress];
        [self.tanksTableView reloadData];
    }
    else if(!self.dispensersTableView.hidden)
    {
        CGPoint currentTouchPosition = [touch locationInView:self.dispensersTableView];
        NSIndexPath *indexPath = [self.dispensersTableView indexPathForRowAtPoint: currentTouchPosition];
        
        //update the question state according to the tap
        NSInteger state = [[self.dispensersQuestionsState objectAtIndex:indexPath.row] integerValue] + 1;
        if(state > 2)
            state = 0;
        [self.dispensersQuestionsState setObject:[NSNumber numberWithInt:state] atIndexedSubscript:indexPath.row];
        
        [self updateProgress];
        [self.dispensersTableView reloadData];
    }
}

- (void)updateProgress
{
    NSUInteger numCompleted = 0;
    for(NSUInteger i=0; i<self.facilityQuestionsState.count; i++)
    {
        NSNumber* state = [self.facilityQuestionsState objectAtIndex:i];
        NSNumber* commentState = [self.facilityQuestionsCommentState objectAtIndex:i];
        if([state integerValue] == 1)
            numCompleted++;
        else if(([state integerValue] == 2) && ([commentState integerValue] == 1))
            numCompleted++;
    }
    for(NSUInteger i=0; i<self.tanksQuestionsState.count; i++)
    {
        NSNumber* state = [self.tanksQuestionsState objectAtIndex:i];
        NSNumber* commentState = [self.tanksQuestionsCommentState objectAtIndex:i];
        if([state integerValue] == 1)
            numCompleted++;
        else if(([state integerValue] == 2) && ([commentState integerValue] == 1))
            numCompleted++;
    }
    for(NSUInteger i=0; i<self.dispensersQuestionsState.count; i++)
    {
        NSNumber* state = [self.dispensersQuestionsState objectAtIndex:i];
        NSNumber* commentState = [self.dispensersQuestionsCommentState objectAtIndex:i];
        if([state integerValue] == 1)
            numCompleted++;
        else if(([state integerValue] == 2) && ([commentState integerValue] == 1))
            numCompleted++;
    }

    float progress = ((float)(numCompleted)/(float)(self.facilityQuestionsState.count + self.tanksQuestionsState.count + self.dispensersQuestionsState.count));
    [self.progressSlider setValue:progress];
    NSInteger percent = (NSInteger)(progress * 100.);
    self.progressLabel.text = [NSString stringWithFormat:@"%d%% Complete", percent];
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
    self.facilityTableView.hidden = NO;
    self.facilityButton.selected = YES;
    self.tanksTableView.hidden = YES;
    self.tanksButton.selected = NO;
    self.dispensersTableView.hidden = YES;
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
    self.facilityTableView.hidden = YES;
    self.facilityButton.selected = NO;
    self.tanksTableView.hidden = NO;
    self.tanksButton.selected = YES;
    self.dispensersTableView.hidden = YES;
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
    self.facilityTableView.hidden = YES;
    self.facilityButton.selected = NO;
    self.tanksTableView.hidden = YES;
    self.tanksButton.selected = NO;
    self.dispensersTableView.hidden = NO;
    self.dispensersButton.selected = YES;
}

@end
