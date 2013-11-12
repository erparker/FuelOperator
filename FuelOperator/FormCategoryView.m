//
//  FormCategoryView.m
//  FuelOperator
//
//  Created by Gary Robinson on 8/27/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "FormCategoryView.h"
#import "InspectionsFormCell.h"
#import "CommentPhotoViewController.h"

#define HEADER_HEIGHT 25
#define BUTTON_HEIGHT 47
#define PROGRESS_HEIGHT 25
#define NAV_BAR_HEIGHT 40

@interface FormCategoryView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *formAnswers;

@end

@implementation FormCategoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.height -= BUTTON_HEIGHT;
    self.tableView.frame = self.bounds;
}

- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor fopOffWhiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)setFormQuestions:(NSArray *)formQuestions
{
    _formQuestions = formQuestions;
    
    NSMutableArray *answers = [[NSMutableArray alloc] initWithCapacity:_formQuestions.count];
    for(FormQuestion *q in _formQuestions)
    {
        FormAnswer *a = [FormAnswer MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"(formQuestion.questionID = %d) AND (inspection.inspectionID = %d)", [q.questionID integerValue], [self.inspection.inspectionID integerValue]]];
        if(!a)
        {
            a = [FormAnswer MR_createEntity];
            a.answer = [NSNumber numberWithInt:kUnanswered];
            a.inspection = self.inspection;
            NSLog(@"added answer with questionID: %d, inspectionID: %d", [q.questionID integerValue], [self.inspection.inspectionID integerValue]);
            a.formQuestion = q;
        }
        [answers addObject:a];
    }
    self.formAnswers = [NSArray arrayWithArray:answers];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [self.tableView reloadData];
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
    return self.formQuestions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormQuestion *question = [self.formQuestions objectAtIndex:indexPath.row];
    FormAnswer *answer = [self.formAnswers objectAtIndex:indexPath.row];
    return [InspectionsFormCell getCellHeightForQuestion:question withAnswer:answer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"inspectionsFormCell";
    
    InspectionsFormCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[InspectionsFormCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withTarget:self];
    
    FormAnswer *answer = [self.formAnswers objectAtIndex:indexPath.row];
    cell.formAnswer = answer;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormAnswer *answer = [self.formAnswers objectAtIndex:indexPath.row];
//    if([answer.answer integerValue] == kNO)
        [self.formCategoryDelegate editCommentPhotosForAnswer:answer];
}

- (void)didSelectAccessory:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    FormAnswer *answer = [self.formAnswers objectAtIndex:indexPath.row];
    
    //update the question state according to the tap
    NSInteger state = [answer.answer integerValue] + 1;
    if(state > kNO)
        state = kUnanswered;
    answer.answer = [NSNumber numberWithInt:state];
    [self.formCategoryDelegate updateProgressView];
    
    //show the changes
    [self.tableView reloadData];
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
