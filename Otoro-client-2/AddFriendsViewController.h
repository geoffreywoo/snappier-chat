//
//  AddFriendsViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/18/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsViewController : UIViewController {
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIButton *addedYou;
    IBOutlet UIButton *contacts;
    IBOutlet UIButton *search;
    
}
-(IBAction) backButton:(id) sender;

@end
