//
//  Toro.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/7/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "Toro.h"

@implementation Toro

const int MAX_TIME = 15;

- (id)initWith:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _toroId = [dict objectForKey:@"_id"];
        _lat = [[dict objectForKey:@"latitude"] floatValue];
        _lng = [[dict objectForKey:@"longitude"] floatValue];
        _read = [[dict objectForKey:@"read"] boolValue];
        _receiverId = [[dict objectForKey:@"receiver"] integerValue];
        _senderId = [[dict objectForKey:@"sender"] integerValue];
            
        _elapsedTime = 0;
        _maxTime = MAX_TIME;
        
        _toroViewController = [[ToroViewController alloc] initWithToro:self];
    }
    return self;
}

@end
