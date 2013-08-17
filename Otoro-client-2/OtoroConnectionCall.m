//
//  OtoroConnectionCall.m
//  Otoro-client-2
//
//  Created by Jono Chang on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "OtoroConnectionCall.h"

@implementation OtoroConnectionCall

- (id)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableData data];
    }
    return self;
}

@end
