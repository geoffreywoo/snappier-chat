//
//  AddFriendsViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/18/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "AddFriendsViewController.h"

@interface AddFriendsViewController ()

@end

@implementation AddFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor blueColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
//    _searchFriendView = [[SearchFriendView alloc] init];
}

-(IBAction) backButton:(id) sender {
    [self.view removeFromSuperview];
}

-(IBAction) addedYouButton:(id) sender {
    _searchFriendView.hidden = YES;
}

-(IBAction) contactsButton:(id) sender {
    _searchFriendView.hidden = YES;
}

-(IBAction) searchButton:(id) sender {
    NSLog(@"Search Button");
    _searchFriendView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
