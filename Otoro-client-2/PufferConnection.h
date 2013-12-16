//
//  OtoroConnection.h
//  Otoro-client-2
//
//  Created by Jono Chang on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "OtoroConnectionCall.h"
#import "OUser.h"
#import "Puffer.h"

@interface PufferConnection : NSObject

// example usage:
//
// [connection getUserWithUserID:@"asdf" completionBlock:^(NSError *error, NSDictionary *returnData){
//      if (error)
//          ...
//      else
//          returnData[@"toros"] ...
// }];

+ (PufferConnection *)sharedInstance;
@property (nonatomic, strong) OUser *user;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *selectedFriends;

// users
- (void)getUserWithUserID:(NSString *)userID completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)createNewUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString*)email phone:(NSString*)phone completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)updateUserEmail:(NSString*)email phone:(NSString*)phone completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)logoutWithUsername:(NSString *)username completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)getFriendMatchesWithPhones:(NSArray *)phones emails:(NSArray *)emails completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)registerDeviceToken:(NSString *)userId withDeviceToken:(NSString *)deviceToken completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)getBadgeCountWithCompletionBlock:(OtoroConnectionCompletionBlock)block;

// puffers
- (void)uploadToroPhoto:(UIImage *)toroImage completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)createNewToro:(Puffer*)toro toReceivers:(NSArray *)users completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)getAllPuffersReceivedWithCompletionBlock:(OtoroConnectionCompletionBlock)block;
- (void)getAllPuffersSentWithCompletionBlock:(OtoroConnectionCompletionBlock)block;
- (void)getAllPuffersWithCompletionBlock:(OtoroConnectionCompletionBlock)block;
- (void)setReadFlagForToroID:(NSString *)toroID completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)swapPuffer:(Puffer *)puffer completionBlock:(OtoroConnectionCompletionBlock)block;

// friends
- (void)getAllFriendsWithCompletionBlock:(OtoroConnectionCompletionBlock)block;
- (void)addFriendWithUserID:(NSString *)userID completionBlock:(OtoroConnectionCompletionBlock)block;
- (void)removeFriendWithUserID:(NSString *)userID completionBlock:(OtoroConnectionCompletionBlock)block;

//upload address book
- (void)uploadAddressBookOf:(NSString*)userName atTime:(NSNumber*)unixTimestamp addressBook:(NSArray*)addressBook completionBlock:(OtoroConnectionCompletionBlock)block;

@end
