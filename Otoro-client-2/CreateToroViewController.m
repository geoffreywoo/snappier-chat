//
//  SendToroViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/11/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "CreateToroViewController.h"
#import "PufferConnection.h"
#import "OtoroChooseVenueViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CreateToroViewController ()< FriendListViewControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) UIImagePickerControllerCameraDevice cameraDevice;
@property (nonatomic, assign) UIImagePickerControllerCameraFlashMode flashMode;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) OVenue *venue;
@property (strong, nonatomic) OtoroChooseVenueViewController *chooseVenueViewController;

@end

@implementation CreateToroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // [self.view sendSubviewToBack:mapView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroundTapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(backgroundTap:)];
    [backgroundView addGestureRecognizer:_backgroundTapGestureRecognizer];
	
	[self changeModes:YES];
    
	_imagePickerController = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        _imagePickerController.delegate = self;
        _imagePickerController.showsCameraControls = NO;
        
        /*
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        CGFloat cameraRatio = 4.0/3.0;
        CGFloat scale = screenSize.height/(screenSize.width * cameraRatio);
        
        // showsCameraControler = NO puts the camera at the top - we need to translate down after scaling to recenter it
        CGFloat cameraHeight = screenSize.width * cameraRatio;
        CGFloat translation = (screenSize.height - cameraHeight)/2;
        
        _imagePickerController.cameraViewTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(scale, scale), CGAffineTransformMakeTranslation(0, translation));
        */
        
        CGSize screenBounds = [UIScreen mainScreen].bounds.size;
        
        CGFloat cameraAspectRatio = 4.0f/3.0f;
        
        CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
        CGFloat scale = screenBounds.height / camViewHeight;
        
        _imagePickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        _imagePickerController.cameraViewTransform = CGAffineTransformScale(_imagePickerController.cameraViewTransform, scale, scale);
        
        
        [self.view addSubview:_imagePickerController.view];
        [self.view sendSubviewToBack:_imagePickerController.view];
        
        // default flash OFF
        _imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        [_flashButton setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];

    }
    else
    {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self.navigationController presentViewController:_imagePickerController animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	[self resetImagePickerSettings];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[message resignFirstResponder];
}

- (void)clearViewState
{
    message.text = @"";
	self.venue = nil;
	[self changeModes:YES];
}

-(void) backgroundTap:(id) sender
{
    NSLog(@"background tapped");
    if (message.hidden) {
        message.hidden = NO;
        [message becomeFirstResponder];
    } else {
        if (message.text.length > 0) {
            if (message.isFirstResponder)
                [message resignFirstResponder];
            else
                [message becomeFirstResponder];
        } else {
            message.hidden = YES;
            [message resignFirstResponder];
        }
    }
}

-(IBAction) backButton:(id) sender
{
	[self clearViewState];
    [[self navigationController] popViewControllerAnimated:YES];
}


- (IBAction)takePhotoButtonPressed:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [_imagePickerController takePicture];
    } else {
        [self.navigationController presentViewController:_imagePickerController animated:NO completion:nil];
    }
}

- (IBAction)flashButtonPressed:(id)sender {
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
	
	if (self.flashMode == UIImagePickerControllerCameraFlashModeOn)
	{
		_imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
		self.flashMode = UIImagePickerControllerCameraFlashModeOff;
		
		[_flashButton setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
	}
	else
	{
		_imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
		self.flashMode = UIImagePickerControllerCameraFlashModeOn;
		
		[_flashButton setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
	}
	
}
- (IBAction)frontBackButtonPressed:(id)sender {
	
	if (self.cameraDevice == UIImagePickerControllerCameraDeviceFront)
	{
		_imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
		self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
		_flashButton.hidden = NO;
		_imagePickerController.cameraFlashMode = self.flashMode; // reset this, might not have been set in viewDidLoad if front camera was on
	}
	else
	{
#pragma warning TODO: do frontback
		_imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
		self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
		_flashButton.hidden = YES;
	}
}

- (IBAction)closeButtonPressed:(id)sender
{
	[self changeModes:YES];
}

-(IBAction) sendToroButton:(id) sender
{
    Puffer *toro = [[Puffer alloc] initOwnToroWithImage:_savedImageView.image expireTimeSetting:self.duration message: message.text venue:self.venue];
	toro.imageKey = _savedImageKey;
    _friendListViewController = nil;
    _friendListViewController = [[FriendListViewController alloc] initWithToro:toro delegate:self];
    
    [[self navigationController] pushViewController:_friendListViewController animated:YES];
}

#pragma mark - FriendListViewController

- (void)friendListViewController:(FriendListViewController *)viewController didSendToro:(Puffer *)toro
{
    NSLog(@"friendListViewController didSendToro: %@",toro);
	[self clearViewState];
	[[self navigationController] popToRootViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)resetImagePickerSettings
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
	_imagePickerController.cameraDevice = self.cameraDevice;
	_imagePickerController.cameraFlashMode = self.flashMode;
    }
    
}

- (void)changeModes:(BOOL)takePhotoMode
{
	if (takePhotoMode)
        _savedImageView.transform = CGAffineTransformMakeRotation(0);
    
    [message resignFirstResponder];
	
	[self resetImagePickerSettings];
    
	_takePhotoButton.hidden = !takePhotoMode;
	_flashButton.hidden = self.cameraDevice != UIImagePickerControllerCameraDeviceRear || !takePhotoMode;
	_frontBackButton.hidden = !takePhotoMode;
	backButton.hidden = !takePhotoMode;
	
	_bottomBackgroundView.hidden = takePhotoMode;
	_closeButton.hidden = takePhotoMode;
	_timeIntervalPicker.hidden = takePhotoMode;
	[_timeIntervalPicker selectRow:2 inComponent:0 animated:NO];
	self.duration = 15 * 60;
	message.hidden = message.text.length == 0 || takePhotoMode;
	backgroundView.hidden = takePhotoMode;
	_savedImageView.hidden = takePhotoMode;
	
	if (!takePhotoMode)
	{
		[sendToroButton setImage:[UIImage imageNamed:@"puffer_small_icon"] forState:UIControlStateNormal];
	}
	else
	{
		_savedImageView.image = nil;
		_savedImageKey = nil;
		
		[sendToroButton setImage:[UIImage imageNamed:@"friends_icon"] forState:UIControlStateNormal];
	}
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *savedImage = info[UIImagePickerControllerOriginalImage];
	
	if (_imagePickerController.cameraDevice ==UIImagePickerControllerCameraDeviceFront)
	{
		// mirror image
		savedImage = [UIImage imageWithCGImage:savedImage.CGImage scale:savedImage.scale orientation:UIImageOrientationLeftMirrored];
	}
    
    CGFloat scaledWidth = self.view.frame.size.height /savedImage.size.height * savedImage.size.width;
    
    CGSize resizedSize = CGSizeMake(scaledWidth, self.view.frame.size.height);
    UIImage *resizedImage = [CreateToroViewController imageWithImage:savedImage scaledToSize:resizedSize];
	
	_savedImageView.image = resizedImage;
    _savedImageView.frame = CGRectMake(0, 0, scaledWidth, self.view.frame.size.height);
    _savedImageView.center = self.view.center;
    _savedImageKey = nil;
    
	[self uploadSavedImage];
	
	[self changeModes:NO];
}
*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *savedImage = info[UIImagePickerControllerOriginalImage];
	
    if (savedImage.size.width >  savedImage.size.height)
    {
        NSLog(@"Select Image is in Landscape Mode ....");
        if (_imagePickerController.cameraDevice ==UIImagePickerControllerCameraDeviceFront)
        {
            // mirror image
            savedImage = [UIImage imageWithCGImage:savedImage.CGImage scale:savedImage.scale orientation:UIImageOrientationLeftMirrored];
        }
        
        CGFloat scaledHeight = self.view.frame.size.width /savedImage.size.width * savedImage.size.height;
        
      //  CGSize resizedSize = CGSizeMake(scaledHeight,self.view.frame.size.width);
        CGSize resizedSize = CGSizeMake(self.view.frame.size.width,scaledHeight);
        UIImage *resizedImage = [CreateToroViewController imageWithImage:savedImage scaledToSize:resizedSize];
        
        _savedImageView.image = resizedImage;
        _savedImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, scaledHeight);
        _savedImageView.center = self.view.center;
        _savedImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        _savedImageKey = nil;
        
        
    }
    else
    {
        NSLog(@"Select Image is in Portrait Mode ...");
        if (_imagePickerController.cameraDevice ==UIImagePickerControllerCameraDeviceFront)
        {
            // mirror image
            savedImage = [UIImage imageWithCGImage:savedImage.CGImage scale:savedImage.scale orientation:UIImageOrientationLeftMirrored];
        }
        
        CGFloat scaledWidth = self.view.frame.size.height /savedImage.size.height * savedImage.size.width;
        
        CGSize resizedSize = CGSizeMake(scaledWidth, self.view.frame.size.height);
        UIImage *resizedImage = [CreateToroViewController imageWithImage:savedImage scaledToSize:resizedSize];
        
        _savedImageView.image = resizedImage;
        _savedImageView.frame = CGRectMake(0, 0, scaledWidth, self.view.frame.size.height);
        //_savedImageView.transform = CGAffineTransformMakeRotation(0);
        _savedImageView.center = self.view.center;
        _savedImageKey = nil;
        
    }
    

	[self uploadSavedImage];
	
	[self changeModes:NO];
}

- (void)uploadSavedImage
{
	// pre-upload saved image
	[[PufferConnection sharedInstance] uploadToroPhoto:_savedImageView.image  completionBlock:^(NSError *error, NSDictionary *returnData) {
		if (error) {
			
		} else {
			if (returnData[@"image"] == _savedImageView.image)
			{
				// if haven't taken a new photo, save the key
				_savedImageKey = returnData[@"key"];
				// let the friendlistviewcontroller know upload finished
				[_friendListViewController imageDidFinishUpload:returnData[@"image"] withKey:returnData[@"key"]];
			}
		}
	}];
}

#pragma mark - UIPicker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 6;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	switch (row) {
        case 0:
            return @"15 seconds";
            break;
		case 1:
			return @"1 minute";
			break;
		case 2:
			return @"5 minutes";
			break;
		case 3:
			return @"15 minutes";
		case 4:
			return @"1 hour";
		case 5:
			return @"1 day";
		default:
			return nil;
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	switch (row) {
        case 0:
            self.duration = 15;
            break;
		case 1:
			self.duration = 60;
			break;
		case 2:
			self.duration = 5 * 60;
			break;
		case 3:
			self.duration = 15 * 60;
			break;
		case 4:
			self.duration = 60 * 60;
			break;
		case 5:
			self.duration = 24 * 60 * 60;
			break;
		default:
			break;
	}
}

@end
