//
//  Toro.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/7/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToroViewController.h"
#import "OVenue.h"
@class ToroViewController;

@interface Toro : NSObject

@property (nonatomic, strong) NSString *toroId;
@property (nonatomic) float lat;
@property (nonatomic) float lng;
@property (nonatomic) bool read;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) OVenue *venue;
@property (nonatomic, strong) NSString *receiver;
@property (nonatomic, strong) NSString *sender;
@property (nonatomic) float created;
@property (nonatomic, strong) NSString *created_string;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UIImageView *statusView;
@property (nonatomic, strong) ToroViewController *toroViewController;
@property (nonatomic) int elapsedTime;
@property (nonatomic) int maxTime;

- (id)initWith:(NSDictionary *)dict;
- (id)initOwnToroWithLat:(float)lat lng:(float)lng message:(NSString*)message venue:(OVenue *)venue;
- (BOOL)isEqual:(id)object;
- (NSComparisonResult)compare:(Toro*)toro;
- (void)print;


@end
