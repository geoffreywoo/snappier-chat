//
//  Toro.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/7/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "Toro.h"

@implementation Toro

- (id)initWith:(NSDictionary *)dict {
    self = [super init];
    if (self) {
    _toroId = [[dict objectForKey:@"id"] integerValue];
    _lat = [[dict objectForKey:@"lat"] floatValue];
    _lng = [[dict objectForKey:@"lng"] floatValue];
    _read = [[dict objectForKey:@"read"] boolValue];
    _receiverId = [[dict objectForKey:@"receiver"] integerValue];
    _senderId = [[dict objectForKey:@"sender"] integerValue];
        
    _elapsedTime = 0;
        
    }
    return self;
}

@end
