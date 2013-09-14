//
//  OtoroConnection.m
//  Otoro-client-2
//
//  Created by Jono Chang on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "OtoroConnection.h"
#import "Toro.h"

NSString *const OTORO_HOST = @"http://otoro.herokuapp.com";

@interface OtoroConnection ()<NSURLConnectionDelegate>
{
    CFMutableDictionaryRef _connectionToCall;
}



@end

@implementation OtoroConnection

+ (OtoroConnection *)sharedInstance
{
    static OtoroConnection *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[OtoroConnection alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _connectionToCall = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        _friends = [[NSMutableArray alloc] init];
        _selectedFriends = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addAPICall:(OtoroConnectionAPIType)apiType completionBlock:(OtoroConnectionCompletionBlock)block toConnection:(NSURLConnection *)connection
{
    OtoroConnectionCall *call = [[OtoroConnectionCall alloc] init];
    call.apiType = apiType;
    call.completionBlock = block;
    CFDictionaryAddValue(_connectionToCall, (__bridge const void *)(connection), (__bridge const void *)call);
}

- (OtoroConnectionCall *)callForConnection:(NSURLConnection *)connection
{
    return CFDictionaryGetValue(_connectionToCall, (__bridge const void *)(connection));
}

- (void)clearConnectionFromDictionaries:(NSURLConnection *)connection
{
    CFDictionaryRemoveValue(_connectionToCall, (__bridge const void *)(connection));
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [[self callForConnection:connection].data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [[self callForConnection:connection].data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error description]);
    
    [self callForConnection:connection].completionBlock(error, nil);
    [self clearConnectionFromDictionaries:connection];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"connection string %@", [[NSString alloc] initWithData:[self callForConnection:connection].data encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    
    OtoroConnectionAPIType apiType = [self callForConnection:connection].apiType;
    if (apiType == OtoroConnectionAPITypeGetUser) {
        // TODO
        NSArray *users = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        if (users && users.count > 0)
        {
            [self callForConnection:connection].completionBlock(error, @{@"user":users[0]});
        }
        else
        {
            [self callForConnection:connection].completionBlock(error, nil);
        }
    } else if (apiType == OtoroConnectionAPITypeCreateUser) {
        NSDictionary *o = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"is return ok? %@",[o objectForKey:@"ok"]);
        if ([[o objectForKey:@"ok"] boolValue]) {
            NSDictionary *user = ((NSArray*)[o objectForKey:@"elements"])[0];
            [self callForConnection:connection].completionBlock(error, @{@"user":user});
        } else {
            error = [NSError errorWithDomain:[o objectForKey:@"error"] code:-1 userInfo:o];
            [self callForConnection:connection].completionBlock(error, nil);
        }
	} else if (apiType == OtoroConnectionAPITypeUpdateUser) {
        NSDictionary *o = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        if ([[o objectForKey:@"ok"] boolValue]) {
            [self callForConnection:connection].completionBlock(error, nil);
        } else {
            error = [NSError errorWithDomain:[o objectForKey:@"error"] code:-1 userInfo:o];
            [self callForConnection:connection].completionBlock(error, nil);
        }
    } else if (apiType == OtoroConnectionAPITypeLogin) {
        NSDictionary *o = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"is return ok? %@",[o objectForKey:@"ok"]);
        if ([[o objectForKey:@"ok"] boolValue]) {
            NSDictionary *user = ((NSArray*)[o objectForKey:@"elements"])[0];
            [self callForConnection:connection].completionBlock(error, @{@"user":user});
        } else {
            error = [NSError errorWithDomain:[o objectForKey:@"error"] code:-1 userInfo:o];
            [self callForConnection:connection].completionBlock(error, nil);
        }
	} else if (apiType == OtoroConnectionAPITypeMatchAddressBook) {
        NSDictionary *o = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        if ([[o objectForKey:@"ok"] boolValue]) {
            [self callForConnection:connection].completionBlock(error, @{@"users":o[@"elements"]});
        } else {
            error = [NSError errorWithDomain:[o objectForKey:@"error"] code:-1 userInfo:o];
            [self callForConnection:connection].completionBlock(error, nil);
        }
    } else if (apiType == OtoroConnectionAPITypeCreateToro) {
        NSArray *jsonToros = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        if (jsonToros)
        {
            [self callForConnection:connection].completionBlock(error, @{@"toros":jsonToros});
        }
        else
        {
            [self callForConnection:connection].completionBlock(error, nil);
        }
    } else if (apiType == OtoroConnectionAPITypeGetReceivedToro) {
        NSDictionary *toroData = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        if (toroData)
        {
            [self callForConnection:connection].completionBlock(error, toroData);
        }
        else
        {
            [self callForConnection:connection].completionBlock(error, nil);
        }
    } else if (apiType == OtoroConnectionAPITypeGetSentToros) {
        NSDictionary *toroData = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        if (toroData)
        {
            [self callForConnection:connection].completionBlock(error, toroData);
        }
        else
        {
            [self callForConnection:connection].completionBlock(error, nil);
        }
    } else if (apiType == OtoroConnectionAPITypeGetAllToros) {
        NSDictionary *toroData = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        if (toroData)
        {
            [self callForConnection:connection].completionBlock(error, toroData);
        }
        else
        {
            [self callForConnection:connection].completionBlock(error, nil);
        }
    } else if (apiType == OtoroConnectionAPITypeSetToroRead) {
        NSArray *jsonToros = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        if (jsonToros)
        {
            [self callForConnection:connection].completionBlock(error, @{@"toros":jsonToros});
        }
        else
        {
            [self callForConnection:connection].completionBlock(error, nil);
        }
    } else if (apiType == OtoroConnectionAPITypeGetFriends) {
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        if (resp)
        {
            _friends = [[NSMutableArray alloc] init];
            NSArray *friends = resp[@"elements"];
            for (int i = 0; i < [friends count]; i++) {
                
                OUser *f = [[OUser alloc] initWithUsername:friends[i][@"user_id"]];
                if ([[[OtoroConnection sharedInstance] selectedFriends] containsObject:f]) {
                    f.selected = YES;
                } else {
                    f.selected = NO;
                }
                
                NSLog(@"friend: %@",f);
                [f debugPrint];
                [_friends addObject:f];
            }
            
            [self callForConnection:connection].completionBlock(error, resp);
        }
        else
        {
            [self callForConnection:connection].completionBlock(error, nil);
        }    } else if (apiType == OtoroConnectionAPITypeAddFriend) {
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        if (resp)
        {
            [self callForConnection:connection].completionBlock(error, resp);
        } 
        else
        {
            [self callForConnection:connection].completionBlock(error, nil);
        }
    } else if (apiType == OtoroConnectionAPITypeRemoveFriends) {
        NSArray *users = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        if (users && users.count > 0)
        {
            [self callForConnection:connection].completionBlock(error, @{@"user":users[0]});
        }
        else
        {
            [self callForConnection:connection].completionBlock(error, nil);
        }
    }
    
    [self clearConnectionFromDictionaries:connection];
}

#pragma mark - Users endpoints

- (void)getUserWithUserID:(NSString *)userID completionBlock:(OtoroConnectionCompletionBlock)block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@", OTORO_HOST, userID]]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeGetUser completionBlock:block toConnection:connection];
}

- (void)createNewUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString*)email phone:(NSString*)phone completionBlock:(OtoroConnectionCompletionBlock)block
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/new", OTORO_HOST]]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@&email=%@&phone=%@", username, password,email, phone] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeCreateUser completionBlock:block toConnection:connection];
}

- (void)updateUserEmail:(NSString *)email phone:(NSString *)phone completionBlock:(OtoroConnectionCompletionBlock)block
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/update/%@", OTORO_HOST, self.user.username]]];
    
    [request setHTTPMethod:@"PUT"];
	NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"phone" : phone, @"email":email} options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:data];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeUpdateUser completionBlock:block toConnection:connection];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completionBlock:(OtoroConnectionCompletionBlock)block
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[NSString stringWithFormat:@"%@/login", OTORO_HOST]]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@", username, password] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeLogin completionBlock:block toConnection:connection];
}

- (void)getFriendMatchesWithPhones:(NSArray *)phones emails:(NSArray *)emails completionBlock:(OtoroConnectionCompletionBlock)block
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/address_book", OTORO_HOST]]];
    
    [request setHTTPMethod:@"POST"];
	NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"phones" : phones, @"emails":emails} options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:data];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeMatchAddressBook completionBlock:block toConnection:connection];
}

#pragma mark - Toros Endpoints

- (void)createNewToro:(Toro*)toro completionBlock:(OtoroConnectionCompletionBlock)block
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"%@/toros/new", OTORO_HOST]]];
    
    [request setHTTPMethod:@"POST"];
	
	NSMutableString *body = [NSMutableString stringWithFormat:@"latitude=%f&longitude=%f&sender=%@&receiver=%@", toro.lat, toro.lng, toro.sender,toro.receiver];
	if (toro.message)
	{
		[body appendFormat:@"&message=%@", toro.message];
	}
	if (toro.venue)
	{
		[body appendFormat:@"&venue=%@&venueID=%@", toro.venue.name, toro.venue.venueID];
	}
	
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeCreateToro completionBlock:block toConnection:connection];
}

- (void)getAllTorosReceivedWithCompletionBlock:(OtoroConnectionCompletionBlock)block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"%@/toros/received/%@", OTORO_HOST, self.user.username]]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeGetReceivedToro completionBlock:block toConnection:connection];
}

- (void)getAllTorosSentWithCompletionBlock:(OtoroConnectionCompletionBlock)block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"%@/toros/sent/%@", OTORO_HOST, self.user.username]]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeGetSentToros completionBlock:block toConnection:connection];
}

- (void)getAllTorosWithCompletionBlock:(OtoroConnectionCompletionBlock)block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"%@/toros/%@", OTORO_HOST, self.user.username]]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeGetAllToros completionBlock:block toConnection:connection];
}

- (void)setReadFlagForToroID:(NSString *)toroID completionBlock:(OtoroConnectionCompletionBlock)block
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[NSString stringWithFormat:@"%@/toros/set_read/%@", OTORO_HOST, toroID]]];
    
    [request setHTTPMethod:@"PUT"];
	NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"read":@YES} options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:data];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeSetToroRead completionBlock:block toConnection:connection];
}

#pragma mark - Friends Endpoints

- (void)getAllFriendsWithCompletionBlock:(OtoroConnectionCompletionBlock)block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"%@/friends/%@", OTORO_HOST, self.user.username]]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeGetFriends completionBlock:block toConnection:connection];
}

- (void)addFriendWithUserID:(NSString *)userID completionBlock:(OtoroConnectionCompletionBlock)block
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[NSString stringWithFormat:@"%@/friends/%@/%@", OTORO_HOST, self.user.username, userID]]];
    
    [request setHTTPMethod:@"POST"];
    //[request setHTTPBody:[[NSString stringWithFormat:@"friend_user_id=%@", userID] dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeAddFriend completionBlock:block toConnection:connection];
}

- (void)removeFriendWithUserID:(NSString *)userID completionBlock:(OtoroConnectionCompletionBlock)block
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[NSString stringWithFormat:@"%@/friends/remove/%@", OTORO_HOST, self.user.username]]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString stringWithFormat:@"friend_user_id=%@", userID] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeRemoveFriends completionBlock:block toConnection:connection];
}


@end
