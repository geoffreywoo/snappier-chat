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
        _addressBookUsers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person,kABPersonLastNameProperty);
    
    [dictionary setObject:firstName forKey:@"firstName"];
    [dictionary setObject:lastName forKey:@"lastName"];
    
    NSMutableArray *phoneNumbersArray = [[NSMutableArray alloc] init];
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i=0; i < ABMultiValueGetCount(phoneNumbers); i++) {
        NSString *phoneNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
        [phoneNumbersArray addObject:phoneNumber];
    }
    [dictionary setObject:phoneNumbersArray forKey:@"phoneNumbers"];

    NSMutableArray *emailsArray = [[NSMutableArray alloc] init];
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (int i=0; i < ABMultiValueGetCount(emails); i++) {
        NSString *email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, i);
        [emailsArray addObject:email];
    }
    [dictionary setObject:emailsArray forKey:@"emails"];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    NSString *userName = [[self addressBookUsers] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendViewCell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", userName];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
