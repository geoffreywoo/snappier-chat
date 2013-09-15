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
    
    _searchViewController = [[SearchViewController alloc] init];

//    _addedYouViewController = [[AddedYouViewController alloc] init];
    [self searchButton:search];
}

-(IBAction) backButton:(id) sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction) addedYouButton:(id) sender {
    [_addressBookViewController.view removeFromSuperview];
    [_searchViewController.view removeFromSuperview];
    [subview2 addSubview:_addedYouViewController.view];
    
    [addedYou setBackgroundColor: [UIColor redColor]];
    [search setBackgroundColor: [UIColor blueColor]];
    [contacts setBackgroundColor: [UIColor blueColor]];
}

-(IBAction) contactsButton:(id) sender {
    if (_addressBookViewController == nil)
        _addressBookViewController = [[AddressBookViewController alloc] init];
    
//    [_addedYouViewController.view removeFromSuperview];
    [_searchViewController.view removeFromSuperview];
    [subview2 addSubview:_addressBookViewController.view];

//    [addedYou setBackgroundColor: [UIColor blueColor]];
    [search setBackgroundColor: [UIColor blueColor]];
    [contacts setBackgroundColor: [UIColor redColor]];
}

-(IBAction) searchButton:(id) sender {
    NSLog(@"Search Button");
//    [_addedYouViewController.view removeFromSuperview];
    [_addressBookViewController.view removeFromSuperview];
    [subview2 addSubview:_searchViewController.view];

//    [addedYou setBackgroundColor: [UIColor blueColor]];
    [search setBackgroundColor: [UIColor redColor]];
    [contacts setBackgroundColor: [UIColor blueColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
