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

@interface Puffer : NSObject

@property (nonatomic, strong, readonly) NSString *toroId;
@property (nonatomic, strong) NSString *imageKey;
@property (nonatomic, strong, readonly) NSURL *imageURL;
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, assign) bool read;
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) OVenue *venue;
@property (nonatomic, strong) NSString *receiver;
@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong, readonly) NSDate *createdDate;
@property (nonatomic, assign, readonly) NSTimeInterval expireTimeInterval;
@property (nonatomic, strong, readonly) NSDate *expireDate;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UIImageView *statusView;
@property (nonatomic, strong) ToroViewController *toroViewController;
@property(atomic, assign) BOOL popped;

- (id)initWith:(NSDictionary *)dict;
- (id)initOwnToroWithImage:(UIImage *)image expireTimeSetting:(NSTimeInterval)expireTimeInterval message:(NSString*)message venue:(OVenue *)venue;
- (id)update:(Puffer*)toro;
- (void)makeTimerLabel;
- (BOOL)isEqual:(id)object;
- (NSComparisonResult)compare:(Puffer*)toro;
- (void)print;
- (NSString *)stringForCreationDate;


@end
