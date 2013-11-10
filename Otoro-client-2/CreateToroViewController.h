//
//  SendToroViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/11/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FriendListViewController.h"

@interface CreateToroViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate,FriendListViewControllerDelegate>
{
	UITapGestureRecognizer *_backgroundTapGestureRecognizer;
	UIImagePickerController *_imagePickerController;
    __weak IBOutlet UIView *backgroundView;
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UIButton *sendToroButton;
	__weak IBOutlet UIButton *_takePhotoButton;
    __weak IBOutlet UIButton *_frontBackButton;
	__weak IBOutlet UIButton *_closeButton;
    __weak IBOutlet UIButton *_flashButton;
    __weak IBOutlet UITextField *message;
	__weak IBOutlet UIPickerView *_timeIntervalPicker;
	__weak IBOutlet UIImageView *_savedImageView;
	NSString *_savedImageKey;

	__weak IBOutlet UIView *_bottomBackgroundView;
}
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) CLLocation *lastLoc;
@property (nonatomic, strong) FriendListViewController *friendListViewController;

-(IBAction) backButton:(id) sender;
-(IBAction) sendToroButton:(id) sender;


@end
