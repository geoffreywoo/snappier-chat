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
    OtoroConnectionAPITypeLogin,
	OtoroConnectionAPITypeMatchAddressBook,
    
    // toros
    OtoroConnectionAPITypeCreateToro,
    OtoroConnectionAPITypeGetReceivedToro,
    OtoroConnectionAPITypeGetSentToros,
    OtoroConnectionAPITypeSetToroRead,
    
    // friends
    OtoroConnectionAPITypeGetFriends,
    OtoroConnectionAPITypeAddFriend,
    OtoroConnectionAPITypeRemoveFriends,
};

typedef void (^OtoroConnectionCompletionBlock)(NSError *error, NSDictionary *returnData);

@interface OtoroConnectionCall : NSObject
@property (nonatomic, assign) OtoroConnectionAPIType apiType;
@property (nonatomic, copy) OtoroConnectionCompletionBlock completionBlock;
@property (nonatomic, strong) NSMutableData *data;
@end
