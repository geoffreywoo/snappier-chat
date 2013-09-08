//
//  AddressBookViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "AddressBookViewController.h"
#import <AddressBook/AddressBook.h>

@interface AddressBookViewController ()

@end

ABAddressBookRef addressBook;

@implementation AddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    addressBook = ABAddressBookCreate();
    CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex n = ABAddressBookGetPersonCount(addressBook);
    
    for( int i = 0 ; i < n ; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex(all, i);
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        NSLog(@"Name %@", firstName);
        
        CFTypeRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
        {
            NSString *phoneLabel = @"";             
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            //CFRelease(phones);
            NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
            CFRelease(phoneNumberRef);
            NSLog(@"  - %@ (%@)", phoneNumber, phoneLabel);
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
