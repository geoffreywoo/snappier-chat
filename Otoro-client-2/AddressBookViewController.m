//
//  AddressBookViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "AddressBookViewController.h"
#import "OtoroConnection.h"
#import <AddressBook/AddressBook.h>

@interface AddressBookViewController ()

@end

ABAddressBookRef addressBook;

@implementation AddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)uploadAddressBook {
    NSLog(@"upload address book");
    addressBook = ABAddressBookCreate();
    CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex n = ABAddressBookGetPersonCount(addressBook);
    
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    for( int i = 0 ; i < n ; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex(all, i);
        NSDictionary *contact = [self shortDictionaryRepresentationForABPerson:ref];
        [contacts addObject:contact];
    }
    
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    NSNumber *unixTimestamp = [NSNumber numberWithInt:ti];
    
    NSLog(@"contacts: %@",contacts);
    [[OtoroConnection sharedInstance] uploadAddressBookOf:[[[OtoroConnection sharedInstance] user] username] atTime:unixTimestamp addressBook:contacts completionBlock:^(NSError *error, NSDictionary *data) {
        if (error) {
            NSLog(@"address upload error: %@",error);
        } else {
            NSLog(@"address upload response: %@",data);
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self uploadAddressBook];
}

- (NSMutableArray *) phoneNumbersForABPerson:(ABRecordRef) person
{
    NSMutableArray *phoneNumbersArray = [[NSMutableArray alloc] init];
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i=0; i < ABMultiValueGetCount(phoneNumbers); i++) {
        NSString *phoneNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
        [phoneNumbersArray addObject:phoneNumber];
    }
    return phoneNumbersArray;
}

- (NSMutableArray *) emailsForABPerson:(ABRecordRef) person
{
    NSMutableArray *emailsArray = [[NSMutableArray alloc] init];
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (int i=0; i < ABMultiValueGetCount(emails); i++) {
        NSString *email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, i);
        [emailsArray addObject:email];
    }
    return emailsArray;
}

- (NSDictionary *) shortDictionaryRepresentationForABPerson:(ABRecordRef) person
{
    NSLog(@"short dictionary representation for ABPerson");
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person,kABPersonLastNameProperty);
    
    [dictionary setObject:firstName forKey:@"first_name"];
    [dictionary setObject:lastName forKey:@"last_name"];
    
    NSMutableArray *phoneNumbersArray = [self phoneNumbersForABPerson:person];
    [dictionary setObject:phoneNumbersArray forKey:@"phone"];

    NSMutableArray *emailsArray = [self emailsForABPerson:person];
    [dictionary setObject:emailsArray forKey:@"email"];
    
    NSMutableArray *addressesArray = [[NSMutableArray alloc] init];
    ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);

    for (int i=0; i < ABMultiValueGetCount(addresses); i++) {
        NSMutableDictionary *addressObj = [[NSMutableDictionary alloc] init];
        CFDictionaryRef address = ABMultiValueCopyValueAtIndex(addresses, i);
       // NSLog(@"address cfdictref: %@", address);
        
        CFStringRef typeTmp = ABMultiValueCopyLabelAtIndex(addresses, i);
        NSString *labeltype = (__bridge NSString *)(ABAddressBookCopyLocalizedLabel(typeTmp));
        NSString *street = (NSString *)CFDictionaryGetValue(address, kABPersonAddressStreetKey);
        NSString *city = (NSString *)CFDictionaryGetValue(address, kABPersonAddressCityKey);
        NSString *state = (NSString *)CFDictionaryGetValue(address, kABPersonAddressStateKey);
        NSString *zip = (NSString *)CFDictionaryGetValue(address, kABPersonAddressZIPKey);
        NSString *country = (NSString *)CFDictionaryGetValue(address, kABPersonAddressCountryKey);
        
        [addressObj setObject:labeltype forKey:@"type"];
        [addressObj setObject:street forKey:@"street"];
        [addressObj setObject:city forKey:@"city"];
        [addressObj setObject:state forKey:@"state"];
        [addressObj setObject:zip forKey:@"zip"];
        [addressObj setObject:country forKey:@"country"];
        
        //NSLog(@"%@", addressObj);
        [addressesArray addObject:addressObj];
    }
    [dictionary setObject:addressesArray forKey:@"address"];
    
    return dictionary;
}

- (NSDictionary *) dictionaryRepresentationForABPerson:(ABRecordRef) person
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    int32_t propertyIndex = 0;
    NSString* propertyName = (__bridge NSString *)ABPersonCopyLocalizedPropertyName(propertyIndex);
    
    while (![propertyName isEqualToString:@"UNKNOWN_PROPERTY"]) {

        id propertyValue = (__bridge id)(ABRecordCopyValue(person, propertyIndex));
        if (propertyValue) {
       
   
            if ( ([propertyValue isKindOfClass:[NSString class]]) || ([propertyValue isKindOfClass:[NSDate class]]) || ([propertyValue isKindOfClass:[NSNumber class]])  ) {
                
            } else {
                NSMutableString *propertyMultiValue = [[NSMutableString alloc] init];
                for(CFIndex j = 0; j < ABMultiValueGetCount((__bridge ABMultiValueRef)(propertyValue)); j++) {
                    CFStringRef ref = ABMultiValueCopyValueAtIndex((__bridge ABMultiValueRef)(propertyValue), j);
                    //CFRelease(phones);
                    NSString *refStr = (__bridge NSString *)ref;
                    CFRelease(ref);
                    [propertyMultiValue appendString:@", "];
                    [propertyMultiValue appendString:refStr];
                }
                propertyValue = propertyMultiValue;
            }
 
            [dictionary setObject:propertyValue forKey:propertyName];

        }
       // NSLog(@"propertyIndex: %d", propertyIndex);
       // NSLog(@"propertyName: %@", propertyName);
       // NSLog(@"propertyValue: %@", propertyValue);
        
        propertyIndex++;
        propertyName = (__bridge NSString *)ABPersonCopyLocalizedPropertyName(propertyIndex);
    }   
    return dictionary;
}

-(void) repForABPerson:(ABRecordRef) person
{
    
    NSLog(@"%@", person);
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSLog(@"Name: %@ %@", firstName, lastName);
    
    CFTypeRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
    {
        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
        //CFRelease(phones);
        NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
        CFRelease(phoneNumberRef);
        NSLog(@"p: %@", phoneNumber);
    }
    CFRelease(phones);
    
    CFTypeRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    for(CFIndex j = 0; j < ABMultiValueGetCount(emails); j++)
    {
        
        CFStringRef emailRef = ABMultiValueCopyValueAtIndex(emails, j);
        NSString *email = (__bridge NSString *)emailRef;
        CFRelease(emailRef);
        NSLog(@"e: %@", email);
    }
    CFRelease(emails);

}

- (NSString *)stringOutputForDictionary:(NSDictionary *)inputDict {
    NSMutableString * outputString = [NSMutableString stringWithCapacity:256];
    
    NSArray * allKeys = [inputDict allKeys];
    
    for (NSString * key in allKeys) {
        if ([[inputDict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            [outputString appendString: [self stringOutputForDictionary: (NSDictionary *)inputDict]];
        }
        else {
            [outputString appendString: key];
            [outputString appendString: @": "];
            [outputString appendString: [[inputDict objectForKey: key] description]];
        }
        [outputString appendString: @"\n"];
    }
    
    return [NSString stringWithString: outputString];
}

-(void)viewDidAppear:(BOOL)animated
{
/*
    addressBook = ABAddressBookCreate();
    CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex n = ABAddressBookGetPersonCount(addressBook);
    
    NSMutableArray *allPhones = [[NSMutableArray alloc] init];
    NSMutableArray *allEmails = [[NSMutableArray alloc] init];
    for( int i = 0 ; i < n ; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex(all, i);
        [allPhones addObjectsFromArray:[self phoneNumbersForABPerson:ref]];
        [allEmails addObjectsFromArray:[self emailsForABPerson:ref]];
    }
    
    _addressBookUsers = [[NSMutableArray alloc] init];
    [[OtoroConnection sharedInstance] getFriendMatchesWithPhones:allPhones emails:allEmails completionBlock:^(NSError *error, NSDictionary *data) {
        if (error) {
        } else {
            NSArray *users = [data objectForKey:@"users"];
            NSLog(@"users: %@",users);
            for (NSDictionary *user in users) {
                NSLog(@"user: %@",user);
                NSString *userName = [user objectForKey:@"_id"];
                NSLog(@"username: %@", userName);
                [_addressBookUsers addObject:userName];
            }
            [addressBookUsersTableView reloadData];
        }
     }];
 */   
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [ [self addressBookUsers] count];
    } else {
        return 0;
    }
}

- (void) toggleFriend:(NSString *)userName inCell:(UITableViewCell*)cell
{
    [[OtoroConnection sharedInstance] addFriendWithUserID:userName completionBlock:^(NSError *error, NSDictionary *returnData) {
        if (error) {
            NSLog(@"Error: %@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Adding friend failed"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            NSLog(@"Return Data: %@" ,returnData);
            bool ok = [[returnData objectForKey:@"ok"] boolValue];
            if (ok) {
                NSArray *arr = [returnData objectForKey:@"elements"];
                NSString *addedFriend = arr[0];
                NSLog(@"added %@",addedFriend);
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Adding friend failed"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    NSString *userName = [[self addressBookUsers] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendViewCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", userName];
    OUser *testUser = [[OUser alloc] initWithUsername:userName];
    
    if ([[[OtoroConnection sharedInstance] friends] containsObject:testUser]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath: %@", indexPath);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSString *userName = [[self addressBookUsers] objectAtIndex:indexPath.row];
    OUser *testUser = [[OUser alloc] initWithUsername:userName];
    if (![[[OtoroConnection sharedInstance] friends] containsObject:testUser]) {
        [self toggleFriend:userName inCell:cell];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"header";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
