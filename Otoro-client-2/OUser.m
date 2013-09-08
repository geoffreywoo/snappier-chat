//
//  Friend.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "OUser.h"

@implementation OUser

- (id)initWithUsername:(NSString *)username {
    self = [super init];
    _username = username;
    return self;
}

- (id)initWith:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _username = [dict objectForKey:@"username"];
        _email = [dict objectForKey:@"email"];
        _phone = [dict objectForKey:@"phone"];
        _preferred = [[dict objectForKey:@"preferred"] boolValue];
        _blocked = [[dict objectForKey:@"blocked"] boolValue];
    }
    return self;
}

- (id)initFromNSDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self = [super init];
    
    if (self) {
        _username = [defaults objectForKey:@"username"];
        _email = [defaults objectForKey:@"email"];
        _phone = [defaults objectForKey:@"phone"];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    OUser* other = object;
    return [self.username isEqualToString:other.username];
}

- (void)debugPrint {
    NSLog(@"username: %@",_username);
    NSLog(@"email: %@",_email);
    NSLog(@"phone: %@",_phone);
}

@end
