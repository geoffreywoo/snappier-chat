//
//  Toro.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/7/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToroViewController.h"
@class ToroViewController;

@interface Toro : NSObject

@property (nonatomic) int toroId;
@property (nonatomic) float lat;
@property (nonatomic) float lng;
@property (nonatomic) bool read;
@property (nonatomic) int receiverId;
@property (nonatomic) int senderId;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) ToroViewController *toroViewController;
@property (nonatomic) int elapsedTime;
@property (nonatomic) int maxTime;

- (id)initWith:(NSDictionary *)dict;


@end
