//
//  Friend.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "OUser.h"

@implementation OUser

- (id)initWith:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _username = [dict objectForKey:@"username"];
        _email = [dict objectForKey:@"email"];
        _phone = [dict objectForKey:@"phone"];
        _preferred = [dict objectForKey:@"preferred"];
    }
    return self;
}


@end
