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
 //       _read = [[dict objectForKey:@"read"] boolValue];
        _receiver = [dict objectForKey:@"receiver"];
        _sender = [dict objectForKey:@"sender"];
        _message = [dict objectForKey:@"message"];
        _venue = [dict objectForKey:@"venue"];
        _created = [dict objectForKey:@"created_at"];
            
        _elapsedTime = 0;
        _maxTime = MAX_TIME;
        
        _toroViewController = [[ToroViewController alloc] initWithToro:self];
    }
    return self;
}

- (id)initOwnToroWithLat:(float)lat lng:(float)lng message:(NSString*)message {
    self = [super init];
    if (self) {
        _lat = lat;
        _lng = lng;
        _message = message;
    }
    return self;
}

- (void) print
{
    NSLog(@"message: %@", _message);
}

@end
