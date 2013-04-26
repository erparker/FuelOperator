//
//  CommentPhotoViewController.m
//  FuelOperator
//
//  Created by Gary Robinson on 3/29/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "CommentPhotoViewController.h"
//#import "InnerShadowView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CommentPhotoViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *fakeNavBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *commentLabel;
//@property (nonatomic, strong) InnerShadowView *shadowView;
@property (nonatomic, strong) UIImageView *commentBackgroundView;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UILabel *photosLabel;
@property (nonatomic, strong) UILabel *noPhotosLabel;
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@property (nonatomic, strong) UIImage *image3;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UIImage *removeImage;
@property (nonatomic, strong) UIButton *removeImageButton1;
@property (nonatomic, strong) UIButton *removeImageButton2;
@property (nonatomic, strong) UIButton *removeImageButton3;
@property (nonatomic, strong) UIButton *takePhotoButton;
@property (nonatomic) NSInteger removeIndex;

@end

@implementation CommentPhotoViewController

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
    
    [self.view addSubview:self.fakeNavBar];
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]];
    
    //load the appropriate comment and images, if they exist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *commentFormat = [NSString stringWithFormat:@"comment_%d.txt", self.row];
    NSString *commentPath = [documentsDirectory stringByAppendingPathComponent:commentFormat];
    
    NSString *comment = [[NSString alloc]initWithContentsOfFile:commentPath usedEncoding:nil error:nil];
    self.commentTextView.text = comment;
    
    
    NSString* path1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.png", self.row, 1]];
    UIImage* image1 = [UIImage imageWithContentsOfFile:path1];
    if(image1)
        self.image1 = image1;
    
    NSString* path2 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.png", self.row, 2]];
    UIImage* image2 = [UIImage imageWithContentsOfFile:path2];
    if(image2)
        self.image2 = image2;
    
    NSString* path3 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.png", self.row, 3]];
    UIImage* image3 = [UIImage imageWithContentsOfFile:path3];
    if(image3)
        self.image3 = image3;
    
    self.imageView1.image = self.image1;
    self.imageView2.image = self.image2;
    self.imageView3.image = self.image3;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showPhotos];
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
        _fakeNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
        
        UIImageView *gradient = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-gradient"]];
        gradient.frame = _fakeNavBar.frame;
        [_fakeNavBar addSubview:gradient];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *cancelImage = [UIImage imageNamed:@"cancel-btn"];
        [cancelButton setImage:cancelImage forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(8, 6, cancelImage.size.width, cancelImage.size.height);
        [cancelButton addTarget:self action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_fakeNavBar addSubview:cancelButton];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(cancelButton.frame.size.width, 3, 200, 45)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldFontOfSize:16];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"Comment / Photo";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_fakeNavBar addSubview:titleLabel];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *saveImage = [UIImage imageNamed:@"save-btn"];
        [saveButton setImage:saveImage forState:UIControlStateNormal];
        saveButton.frame = CGRectMake(260, 6, saveImage.size.width, saveImage.size.height);
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
    //?? save the coments and images to the docs directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //comments
    NSString *commentFormat = [NSString stringWithFormat:@"comment_%d.txt", self.row];
    NSString *commentPath = [documentsDirectory stringByAppendingPathComponent:commentFormat];
    if(![self.commentTextView.text isEqualToString:@""])
        [self.commentTextView.text writeToFile:commentPath atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
    else
        [[NSFileManager defaultManager] removeItemAtPath:commentPath error:nil];
    
    //images
    if(self.image1)
    {
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.png", self.row, 1]];
        NSData* data = UIImagePNGRepresentation(self.image1);
        [data writeToFile:path atomically:YES];
    }
    if(self.image2)
    {
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.png", self.row, 2]];
        NSData* data = UIImagePNGRepresentation(self.image2);
        [data writeToFile:path atomically:YES];
    }
    if(self.image3)
    {
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.png", self.row, 3]];
        NSData* data = UIImagePNGRepresentation(self.image3);
        [data writeToFile:path atomically:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIScrollView*)scrollView
{
    if(_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width, self.view.bounds.size.height - 45)];
        _scrollView.backgroundColor = [UIColor fopOffWhiteColor];
        
        //?? read the docs dir here and load up the images and comment
        
        [_scrollView addSubview:self.questionLabel];
        [_scrollView addSubview:self.commentLabel];
        [_scrollView addSubview:self.commentBackgroundView];
        [_scrollView addSubview:self.commentTextView];
        [_scrollView addSubview:self.photosLabel];
        [_scrollView addSubview:self.noPhotosLabel];
        [_scrollView addSubview:self.imageView1];
        [_scrollView addSubview:self.removeImageButton1];
        [_scrollView addSubview:self.imageView2];
        [_scrollView addSubview:self.removeImageButton2];
        [_scrollView addSubview:self.imageView3];
        [_scrollView addSubview:self.removeImageButton3];
        [_scrollView addSubview:self.takePhotoButton];
        
        [self showPhotos];
    }
    return _scrollView;
}

- (UILabel*)questionLabel
{
    if(_questionLabel == nil)
    {
        _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, self.view.bounds.size.width - 20, 30)];
        _questionLabel.backgroundColor = [UIColor clearColor];
        _questionLabel.font = [UIFont boldFontOfSize:20];
        _questionLabel.textColor = [UIColor fopDarkGreyColor];
        _questionLabel.text = self.question;
        _questionLabel.numberOfLines = 0;
        [_questionLabel sizeToFit];
    }
    return _questionLabel;
}

- (UILabel*)commentLabel
{
    if(_commentLabel == nil)
    {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35 + self.questionLabel.frame.size.height, self.view.bounds.size.width - 20, 30)];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.font = [UIFont boldFontOfSize:20];
        _commentLabel.textColor = [UIColor fopDarkGreyColor];
        _commentLabel.text = @"Comments";
    }
    return _commentLabel;
}

//- (InnerShadowView*)shadowView
//{
//    if(_shadowView == nil)
//    {
//        _shadowView = [[InnerShadowView alloc] initWithFrame:CGRectMake(10, 65 + self.questionLabel.frame.size.height, self.view.bounds.size.width - 20, 130)];
//        _shadowView.layer.cornerRadius = 10;
//        _shadowView.layer.masksToBounds = YES;
//    }
//    return _shadowView;
//}

- (UIImageView*)commentBackgroundView
{
    if(_commentBackgroundView == nil)
    {
        UIImage *commentBackgroundImage = [UIImage imageNamed:@"commentBackground"];
        commentBackgroundImage = [commentBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 12, 12)];
        
        _commentBackgroundView = [[UIImageView alloc] initWithImage:commentBackgroundImage];
        _commentBackgroundView.contentMode = UIViewContentModeScaleToFill;
        _commentBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _commentBackgroundView.frame = CGRectMake(10, 65 + self.questionLabel.frame.size.height, self.view.bounds.size.width - 20, 130);
        
        _commentBackgroundView.layer.cornerRadius = 5;//10;
        _commentBackgroundView.layer.masksToBounds = YES;
    }
    return _commentBackgroundView;
}

- (UITextView*)commentTextView
{
    if(_commentTextView == nil)
    {
        _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 65 + self.questionLabel.frame.size.height, self.view.bounds.size.width - 30, 130)];
        _commentTextView.backgroundColor = [UIColor clearColor];
        _commentTextView.layer.cornerRadius = 10;
        _commentTextView.layer.masksToBounds = YES;
        _commentTextView.font = [UIFont regularFontOfSize:18];
        _commentTextView.textColor = [UIColor fopDarkGreyColor];
        _commentTextView.delegate = self;
    }
    return _commentTextView;
}

- (void)viewTapped:(id)sender
{
    [self.commentTextView resignFirstResponder];
}

- (UILabel*)photosLabel
{
    if(_photosLabel == nil)
    {
        _photosLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 215 + self.questionLabel.frame.size.height, self.view.bounds.size.width - 20, 30)];
        _photosLabel.backgroundColor = [UIColor clearColor];
        _photosLabel.font = [UIFont boldFontOfSize:20];
        _photosLabel.textColor = [UIColor fopDarkGreyColor];
        _photosLabel.text = @"Photos";
    }
    return _photosLabel;
}

- (UILabel*)noPhotosLabel
{
    if(_noPhotosLabel == nil)
    {
        _noPhotosLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 245 + self.questionLabel.frame.size.height, self.view.bounds.size.width - 20, 20)];
        _noPhotosLabel.backgroundColor = [UIColor clearColor];
        _noPhotosLabel.font = [UIFont regularFontOfSize:16];
        _noPhotosLabel.textColor = [UIColor fopDarkGreyColor];
        _noPhotosLabel.text = @"There are currently no photos attached to this question.";
        _noPhotosLabel.numberOfLines = 0;
        [_noPhotosLabel sizeToFit];
    }
    return _noPhotosLabel;
}

- (UIImage*)removeImage
{
    if(_removeImage == nil)
    {
        _removeImage = [UIImage imageNamed:@"removeButtonImage"];
    }
    return _removeImage;
}

- (UIImageView*)imageView1
{
    if(_imageView1 == nil)
    {
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 255 + self.questionLabel.frame.size.height, 90, 70)];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView1;
}

- (UIButton*)removeImageButton1
{
    if(_removeImageButton1 == nil)
    {
        _removeImageButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _removeImageButton1.frame = CGRectMake(10, 340 + self.questionLabel.frame.size.height, 90, 28);
        [_removeImageButton1 setImage:[UIImage imageNamed:@"removeButtonImage"] forState:UIControlStateNormal];
        [_removeImageButton1 addTarget:self action:@selector(removeImageButton1Tapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeImageButton1;
}

- (void)removeImageButton1Tapped:(id)sender
{
    self.removeIndex = 1;
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Delete Photo"];
	[alert setMessage:@"Are you sure?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        if(self.removeIndex == 1)
        {
            if(self.image2)
            {
                self.image1 = self.image2;
                if(self.image3)
                {
                    self.image2 = self.image3;
                    self.image3 = nil;
                }
                else
                    self.image2 = nil;
            }
            else
                self.image1 = nil;
        }
        else if(self.removeIndex == 2)
        {
            if(self.image3)
            {
                self.image2 = self.image3;
                self.image3 = nil;
            }
            else
                self.image2 = nil;
        }
        else
        {
            self.image3 = nil;
        }
        
        [self showPhotos];
	}
}

- (UIImageView*)imageView2
{
    if(_imageView2 == nil)
    {
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(115, 255 + self.questionLabel.frame.size.height, 90, 70)];
        _imageView2.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView2;
}

- (UIButton*)removeImageButton2
{
    if(_removeImageButton2 == nil)
    {
        _removeImageButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _removeImageButton2.frame = CGRectMake(115, 340 + self.questionLabel.frame.size.height, 90, 28);
        [_removeImageButton2 setImage:[UIImage imageNamed:@"removeButtonImage"] forState:UIControlStateNormal];
        [_removeImageButton2 addTarget:self action:@selector(removeImageButton2Tapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeImageButton2;
}

- (void)removeImageButton2Tapped:(id)sender
{
    self.removeIndex = 2;
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Delete Photo"];
	[alert setMessage:@"Are you sure?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
}

- (UIImageView*)imageView3
{
    if(_imageView3 == nil)
    {
        _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(220, 255 + self.questionLabel.frame.size.height, 90, 70)];
        _imageView3.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView3;
}

- (UIButton*)removeImageButton3
{
    if(_removeImageButton3 == nil)
    {
        _removeImageButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _removeImageButton3.frame = CGRectMake(220, 340 + self.questionLabel.frame.size.height, 90, 28);
        [_removeImageButton3 setImage:[UIImage imageNamed:@"removeButtonImage"] forState:UIControlStateNormal];
        [_removeImageButton3 addTarget:self action:@selector(removeImageButton3Tapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeImageButton3; 
}

//
- (void)removeImageButton3Tapped:(id)sender
{
    self.removeIndex = 3;
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Delete Photo"];
	[alert setMessage:@"Are you sure?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
}

- (UIButton*)takePhotoButton
{
    if(_takePhotoButton == nil)
    {
        _takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"take-photo-btn"];
        [_takePhotoButton setImage:image forState:UIControlStateNormal];
        _takePhotoButton.frame = CGRectMake(10, 285 + self.questionLabel.frame.size.height, image.size.width, image.size.height);
        [_takePhotoButton addTarget:self action:@selector(takePhotoTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoButton;
}

- (void)takePhotoTapped:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        return;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    cameraUI.delegate = self;
    cameraUI.allowsEditing = YES;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[[picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageToSave = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    if(!imageToSave)
        imageToSave = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];;
    
    
    if(!self.image1)
        self.image1 = imageToSave;
    else if(!self.image2)
        self.image2 = imageToSave;
    else
        self.image3 = imageToSave;
    
    [self showPhotos];

    //[[picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPhotos
{
    self.takePhotoButton.enabled = YES;
    
    if(!self.image1)
    {
        self.noPhotosLabel.hidden = NO;
        self.imageView1.hidden = YES;
        self.removeImageButton1.hidden = YES;
        self.imageView2.hidden = YES;
        self.removeImageButton2.hidden = YES;
        self.imageView3.hidden = YES;
        self.removeImageButton3.hidden = YES;
        
        CGRect rect = self.takePhotoButton.frame;
        rect.origin.y = 285 + self.questionLabel.frame.size.height;
        self.takePhotoButton.frame = rect;
    }
    else
    {
        self.noPhotosLabel.hidden = YES;
        self.imageView1.hidden = NO;
        self.removeImageButton1.hidden = NO;
        
        if(self.image2)
        {
            self.imageView2.hidden = NO;
            self.removeImageButton2.hidden = NO;
        }
        else
        {
            self.imageView2.hidden = YES;
            self.removeImageButton2.hidden = YES;
        }
        
        if(self.image3)
        {
            self.imageView3.hidden = NO;
            self.removeImageButton3.hidden = NO;
        }
        else
        {
            self.imageView3.hidden = YES;
            self.removeImageButton3.hidden = YES;
        }
        
        CGRect rect = self.takePhotoButton.frame;
        rect.origin.y = 380 + self.questionLabel.frame.size.height;
        self.takePhotoButton.frame = rect;
    }
    
    self.imageView1.image = self.image1;
    self.imageView2.image = self.image2;
    self.imageView3.image = self.image3;
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.takePhotoButton.frame.origin.y + self.takePhotoButton.frame.size.height + 10);
}

@end
