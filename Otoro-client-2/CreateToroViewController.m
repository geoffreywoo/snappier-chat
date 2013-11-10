//
//  SendToroViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/11/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "CreateToroViewController.h"
#import "OtoroConnection.h"
#import "OtoroChooseVenueViewController.h"
#import "SnapperMapAnnotation.h"
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
    
//    mapView.showsUserLocation = YES;
	
	_imagePickerController = [[UIImagePickerController alloc] init];
	_imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	_imagePickerController.delegate = self;
	_imagePickerController.showsCameraControls = NO;
	
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	
	CGFloat cameraRatio = 4.0/3.0;
	CGFloat scale = screenSize.height/(screenSize.width * cameraRatio);
	
	// showsCameraControler = NO puts the camera at the top - we need to translate down after scaling to recenter it
	CGFloat cameraHeight = screenSize.width * cameraRatio;
	CGFloat translation = (screenSize.height - cameraHeight)/2;
	
	_imagePickerController.cameraViewTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(scale, scale), CGAffineTransformMakeTranslation(0, translation));
	
	_imagePickerController.view.frame = self.view.frame;
	
	[self.view addSubview:_imagePickerController.view];
	[self.view sendSubviewToBack:_imagePickerController.view];
	
	// default flash OFF
	_imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
	[_flashButton setTitle:@"OFF" forState:UIControlStateNormal];
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

- (void) initLocationManager
{
    NSLog(@"loc manager init");
//    [locationManager setDelegate:self];
//    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"location manager did update locations");
    NSLog(@"%@",locations);
    
    _lastLoc = [locations objectAtIndex:[locations count]-1];
    NSLog(@"lastLoc: %@", _lastLoc);

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta=0.005;
    span.longitudeDelta=0.005;
    
    region.span=span;
    region.center=_lastLoc.coordinate;
    
//    [mapView setRegion:region animated:TRUE];
//    [mapView regionThatFits:region];

  //  if ([_lastLoc horizontalAccuracy] < 10) {
  //      [manager stopUpdatingLocation];
  //  }

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
/*
-(IBAction) friendListButton:(id) sender
{
    NSLog(@"friends view");
    
    if (_friendListViewController == nil) {
        _friendListViewController = [[FriendListViewController alloc] init];
    }
    
    [self.view addSubview:_friendListViewController.view];
}
*/

- (IBAction)takePhotoButtonPressed:(id)sender {
	[_imagePickerController takePicture];
}

- (IBAction)flashButtonPressed:(id)sender {
	
	if (self.flashMode == UIImagePickerControllerCameraFlashModeOn)
	{
		_imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
		self.flashMode = UIImagePickerControllerCameraFlashModeOff;
		
		[_flashButton setTitle:@"OFF" forState:UIControlStateNormal];
	}
	else
	{
		_imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
		self.flashMode = UIImagePickerControllerCameraFlashModeOn;
		
		[_flashButton setTitle:@"ON" forState:UIControlStateNormal];
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
    Toro *toro = [[Toro alloc] initOwnToroWithImage:_savedImageView.image expireTimeSetting:self.duration message: message.text venue:self.venue];
	toro.imageKey = _savedImageKey;
    _friendListViewController = nil;
    _friendListViewController = [[FriendListViewController alloc] initWithToro:toro delegate:self];
    
    [[self navigationController] pushViewController:_friendListViewController animated:YES];
}

#pragma mark - FriendListViewController

- (void)friendListViewController:(FriendListViewController *)viewController didSendToro:(Toro *)toro
{
	[self clearViewState];
	[[self navigationController] popToRootViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)resetImagePickerSettings
{
	_imagePickerController.cameraDevice = self.cameraDevice;
	_imagePickerController.cameraFlashMode = self.flashMode;
}

- (void)changeModes:(BOOL)takePhotoMode
{
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
		[sendToroButton setImage:[UIImage imageNamed:@"snappermap_inapp_icon_small"] forState:UIControlStateNormal];
	}
	else
	{
		_savedImageView.image = nil;
		_savedImageKey = nil;
		
		[sendToroButton setImage:[UIImage imageNamed:@"friends_icon"] forState:UIControlStateNormal];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *savedImage = info[UIImagePickerControllerOriginalImage];
	
	if (_imagePickerController.cameraDevice ==UIImagePickerControllerCameraDeviceFront)
	{
		// mirror image
		savedImage = [UIImage imageWithCGImage:savedImage.CGImage scale:savedImage.scale orientation:UIImageOrientationLeftMirrored];
	}
	
	CGFloat scaledWidth = self.view.frame.size.height /savedImage.size.height * savedImage.size.width;
	
	_savedImageView.image = savedImage;
	_savedImageView.frame = CGRectMake(0, 0, scaledWidth, self.view.frame.size.height);
	_savedImageView.center = self.view.center;
	_savedImageKey = nil;
	
	[self uploadSavedImage];
	
	[self changeModes:NO];
}

- (void)uploadSavedImage
{
	// pre-upload saved image
	[[OtoroConnection sharedInstance] uploadToroPhoto:_savedImageView.image  completionBlock:^(NSError *error, NSDictionary *returnData) {
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
	return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	switch (row) {
		case 0:
			return @"1 minute";
			break;
		case 1:
			return @"5 minutes";
			break;
		case 2:
			return @"15 minutes";
		case 3:
			return @"1 hour";
		case 4:
			return @"1 day";
		default:
			return nil;
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	switch (row) {
		case 0:
			self.duration = 60;
			break;
		case 1:
			self.duration = 5 * 60;
			break;
		case 2:
			self.duration = 15 * 60;
			break;
		case 3:
			self.duration = 60 * 60;
			break;
		case 4:
			self.duration = 24 * 60 * 60;
			break;
		default:
			break;
	}
}

@end
