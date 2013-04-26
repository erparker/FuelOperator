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

@interface InspectionFormViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *facilityButton;
@property (nonatomic, strong) UIButton *tanksButton;
@property (nonatomic, strong) UIButton *dispensersButton;
@property (nonatomic, strong) UILabel *navigationLabel;

@property (nonatomic, strong) NSMutableArray *questionsState;
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) NSMutableArray *questionsCommentState;

@end

@implementation InspectionFormViewController

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
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.facilityButton];
    [self.view addSubview:self.tanksButton];
    [self.view addSubview:self.dispensersButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.titleView = self.navigationLabel;
    
    self.questionsState = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    
    self.questionsCommentState = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    
    self.questions = [[NSMutableArray alloc] initWithObjects:@"Is emergency response plan present?", @"UST Permit present and not expired?", @"Are all operator records present?", @"ATG working properly and not in alarm?", @"Are vents and vent caps undamaged?", @"Are fire extinguishers located within 100' of dispensers and not expired?", @"Is ESO located within 100' of dispensers and working properly?", @"Have all employees passed Class C Operator training and have proof?", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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

- (UITableView*)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, PROGRESS_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - PROGRESS_HEIGHT - BUTTON_HEIGHT - NAV_BAR_HEIGHT)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor fopOffWhiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *commentFormat = [NSString stringWithFormat:@"comment_%d.txt", indexPath.row];
    NSString *commentPath = [documentsDirectory stringByAppendingPathComponent:commentFormat];
    NSString *comment = [[NSString alloc]initWithContentsOfFile:commentPath usedEncoding:nil error:nil];
    if(comment)
    {
        bHasComment = YES;
    }
    else
    {
        NSString* path1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.png", indexPath.row, 1]];
        UIImage* image1 = [UIImage imageWithContentsOfFile:path1];
        if(image1)
            bHasComment = YES;
    }
    [self.questionsCommentState setObject:[NSNumber numberWithBool:bHasComment] atIndexedSubscript:indexPath.row];
    
    
    NSNumber* state = [self.questionsState objectAtIndex:indexPath.row];
    NSString* question = [self.questions objectAtIndex:indexPath.row];
    NSNumber* hasComment = [self.questionsCommentState objectAtIndex:indexPath.row];
    CGFloat height = [InspectionsFormCell getCellHeightForQuestion:question withState:[state integerValue] withComment:[hasComment integerValue]];
    //NSLog(@"height at row %d: %f\n", indexPath.row, height);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"inspectionsFormCell";
    
    InspectionsFormCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[InspectionsFormCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withTarget:self];
    
    //?? make an enumeration for the states
    //?? check the documents directory to see if there are comments/photos to set the state
    NSNumber *curState = [self.questionsState objectAtIndex:indexPath.row];
    cell.state = [curState integerValue];
    cell.question = [self.questions objectAtIndex:indexPath.row];
    cell.commentState = [[self.questionsCommentState objectAtIndex:indexPath.row] integerValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentPhotoViewController *commentPhotoVC = [[CommentPhotoViewController alloc] init];
    commentPhotoVC.question = [self.questions objectAtIndex:indexPath.row];
    commentPhotoVC.row = indexPath.row;
    [self presentViewController:commentPhotoVC animated:YES completion:nil];
}

- (void)didSelectAccessory:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    //update the question state according to the tap
    NSInteger state = [[self.questionsState objectAtIndex:indexPath.row] integerValue] + 1;
    if(state > 2)
        state = 0;
    [self.questionsState setObject:[NSNumber numberWithInt:state] atIndexedSubscript:indexPath.row];
    
    [self updateProgress];
    [self.tableView reloadData];
}

- (void)updateProgress
{
    NSUInteger numCompleted = 0;
    for(NSUInteger i=0; i<self.questionsState.count; i++)
    {
        NSNumber* state = [self.questionsState objectAtIndex:i];
        NSNumber* commentState = [self.questionsCommentState objectAtIndex:i];
        if([state integerValue] == 1)
            numCompleted++;
        else if(([state integerValue] == 2) && ([commentState integerValue] == 1))
            numCompleted++;
    }
    float progress = ((float)(numCompleted)/(float)(self.questionsState.count));
    [self.progressSlider setValue:progress];
    NSInteger percent = (NSInteger)(progress * 100.);
    self.progressLabel.text = [NSString stringWithFormat:@"%d%% Complete", percent];
}

- (UIButton*)facilityButton
{
    if(_facilityButton == nil)
    {
        _facilityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _facilityButton.frame = CGRectMake(0, self.view.bounds.size.height - BUTTON_HEIGHT - NAV_BAR_HEIGHT, 110, BUTTON_HEIGHT);
        [_facilityButton setImage:[UIImage imageNamed:@"facility-btn-normal.png"] forState:UIControlStateNormal];
        [_facilityButton setImage:[UIImage imageNamed:@"facility-btn-selected.png"] forState:UIControlStateSelected];
    }
    return _facilityButton;
}

- (UIButton*)tanksButton
{
    if(_tanksButton == nil)
    {
        _tanksButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tanksButton.frame = CGRectMake(110, self.view.bounds.size.height - BUTTON_HEIGHT - NAV_BAR_HEIGHT, 110, BUTTON_HEIGHT);
        [_tanksButton setImage:[UIImage imageNamed:@"tanks-btn-normal"] forState:UIControlStateNormal];
        [_tanksButton setImage:[UIImage imageNamed:@"tanks-btn-selected"] forState:UIControlStateSelected];
    }
    return _tanksButton;
}

- (UIButton*)dispensersButton
{
    if(_dispensersButton == nil)
    {
        _dispensersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dispensersButton.frame = CGRectMake(self.view.bounds.size.width - 103, self.view.bounds.size.height - BUTTON_HEIGHT - NAV_BAR_HEIGHT, 103, BUTTON_HEIGHT);
        [_dispensersButton setImage:[UIImage imageNamed:@"dispensers-btn-normal"] forState:UIControlStateNormal];
        [_dispensersButton setImage:[UIImage imageNamed:@"dispensers-btn-selected"] forState:UIControlStateSelected];
    }
    return _dispensersButton;
}

@end
