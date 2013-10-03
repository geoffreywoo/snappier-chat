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
        _receiver = [dict objectForKey:@"receiver"];
        _sender = [dict objectForKey:@"sender"];
        _message = [dict objectForKey:@"message"];
      
        _created = [[dict objectForKey:@"created_at"] floatValue];
        
        _popped = false;
        
        NSTimeInterval interval = _created;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"EEE, MMM dd h:mm a"];
        _created_string = [formatter stringFromDate:date];
	
		OVenue *venue = [[OVenue alloc] init];
		venue.name = dict[@"venue"];
		venue.venueID = dict[@"venueID"];
		_venue = venue;
		
        if (_read)
            _elapsedTime = 15;
        else
            _elapsedTime = 0;
        _maxTime = MAX_TIME;
        
        _toroViewController = [[ToroViewController alloc] initWithToro:self];
        _timerLabel = [[UILabel alloc] init];
        [_timerLabel setText:[NSString stringWithFormat:@""]];
    }
    return self;
}

- (id)initOwnToroWithLat:(float)lat lng:(float)lng message:(NSString*)message venue:(OVenue *)venue
{
    self = [super init];
    if (self) {
        _lat = lat;
        _lng = lng;
        _message = message;
		_venue = venue;
    }
    return self;
}

- (id) update:(Toro*)toro {
    _read = [toro read];
    return self;
}

- (void)makeTimerLabel
{
    [_timerLabel setFont:[UIFont systemFontOfSize:12]];
    if (!_read)
        [_timerLabel setText:[NSString stringWithFormat:@""]];
    else if (_read && (_maxTime == _elapsedTime)) {
        [_timerLabel setText:[NSString stringWithFormat:@""]];
    } else {
        int timeLeft = (_maxTime - _elapsedTime);
        [_timerLabel setText:[NSString stringWithFormat:@"%d",timeLeft]];
    }

}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    Toro* other = object;
    return [self.toroId isEqualToString:other.toroId];
}

- (NSComparisonResult)compare:(Toro*)toro {
    if (self.created < toro.created)
        return NSOrderedDescending;
    else if (self.created > toro.created)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}


- (void) print
{
    NSLog(@"lat: %f, lng: %f, sender: %@, receiver: %@, message: %@, venue: %@, timestamp: %f", _lat, _lng, _sender, _receiver, _message, _venue.name, _created);
}

@end
