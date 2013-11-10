//
//  OtoroConnectionCall.h
//  Otoro-client-2
//
//  Created by Jono Chang on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OtoroConnectionAPIType)
{
    // users
    OtoroConnectionAPITypeGetUser,
    OtoroConnectionAPITypeCreateUser,
	OtoroConnectionAPITypeUpdateUser,
    OtoroConnectionAPITypeLogin,
    OtoroConnectionAPITypeLogout,
	OtoroConnectionAPITypeMatchAddressBook,
    OtoroConnectionAPITypeRegisterDeviceToken,
    OtoroConnectionAPITypeUnregisterDeviceToken,
    OtoroConnectionAPITypeGetBadgeCount,
    
    // toros
	OtoroConnectionAPITypeUploadToroPhoto,
    OtoroConnectionAPITypeCreateToro,
    OtoroConnectionAPITypeGetReceivedToro,
    OtoroConnectionAPITypeGetSentToros,
    OtoroConnectionAPITypeSetToroRead,
    OtoroConnectionAPITypeGetAllToros,
	OtoroConnectionAPITypeBlurPhoto,
    
    // friends
    OtoroConnectionAPITypeGetFriends,
    OtoroConnectionAPITypeAddFriend,
    OtoroConnectionAPITypeRemoveFriends,
    
    //address book
    OtoroConnectionAPITypeUploadAddressBook,
    
};

typedef void (^OtoroConnectionCompletionBlock)(NSError *error, NSDictionary *returnData);

@interface OtoroConnectionCall : NSObject
@property (nonatomic, assign) OtoroConnectionAPIType apiType;
@property (nonatomic, copy) OtoroConnectionCompletionBlock completionBlock;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSMutableData *data;
@end
