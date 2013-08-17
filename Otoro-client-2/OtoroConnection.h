//
//  OtoroConnection.h
//  Otoro-client-2
//
//  Created by Jono Chang on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface OtoroConnection : NSObject

typedef void (^OtoroConnectionCompletionBlock)(NSError *error, NSDictionary *returnData);

// example usage:
//
// [connection getUserWithUserID:@"asdf" completionBlock:^(NSError *error, NSDictionary *returnData){
//      if (error)
//          ...
//      else
//          returnData[@"toros"] ...
// }];

// users
- (void)getUserWithUserID:(NSString *)userID completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)createNewUserWithUsername:(NSString *)username password:(NSString *)password completionBlock:(OtoroConnectionCompletionBlock)block;

// toros
- (void)createNewToroWithLocation:(CLLocation *)location andReceiverUserID:(NSString *)receiverUserID completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)getAllTorosReceivedWithCompletionBlock:(OtoroConnectionCompletionBlock)block;
- (void)getAllTorosSentWithCompletionBlock:(OtoroConnectionCompletionBlock)block;
- (void)setReadFlagForToroID:(NSString *)toroID completionBlock:(OtoroConnectionCompletionBlock)block;

// friends
- (void)getAllFriendsWithCompletionBlock:(OtoroConnectionCompletionBlock)block;
- (void)addFriendWithUserID:(NSString *)userID completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)removeFriendWithUserID:(NSString *)userID completionBlock:(OtoroConnectionCompletionBlock)block;
@end
