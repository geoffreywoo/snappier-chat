//
//  FriendListViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "FriendListViewController.h"
#import "OtoroConnection.h"
#import "Friend.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[OtoroConnection sharedInstance] getAllFriendsWithCompletionBlock:^(NSError *error, NSDictionary *data){
            if (error) {
                
            } else {
                _friends = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < [data[@"friends"] count]; i++) {
                    Friend *f = [[Friend alloc] initWith:data[@"friends"][i]];
                    NSLog(@"friend: %@",f);
                    [_friends addObject:f];
                }
                [friendTableView reloadData];
            }
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSLog(@"%d",[ [self friends] count]);
        return [ [self friends] count];
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"header";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellForRowAtIndexPath");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendViewCell"];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendViewCell"];
    }
    
    Friend *f = [[self friends] objectAtIndex:[indexPath row]];
    NSLog(@"%@",f);
    
    cell.textLabel.text = [NSString stringWithFormat:@"friend: %@", [f username]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    UIButton *button = [[UIButton alloc] init];
    button.tag = indexPath.row;
    CGRect frame = cell.frame;
    [button setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
    [button addTarget:self action:@selector(toggleFriend:) forControlEvents: UIControlEventTouchDown];
    [cell addSubview:button];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
