//
//  Friend.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "Friend.h"

@implementation Friend

- (id)initWith:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _username = [dict objectForKey:@"username"];
        _preferred = [dict objectForKey:@"preferred"];
    }
    return self;
}


@end
