//
//  OtoroConnection.m
//  Otoro-client-2
//
//  Created by Jono Chang on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "OtoroConnection.h"

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
    
    NSError *error;
    if ([self callForConnection:connection].apiType == OtoroConnectionAPITypeGetReceivedToro)
    {
        NSArray *jsonToros = [NSJSONSerialization JSONObjectWithData:[self callForConnection:connection].data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"jsonToros: %@",jsonToros);
        [self callForConnection:connection].completionBlock(error, @{@"toros":jsonToros});
        [self clearConnectionFromDictionaries:connection];
    }
}


- (void)createNewToroWithLocation:(CLLocation *)location andReceiverUserID:(NSString *)receiverUserID completionBlock:(OtoroConnectionCompletionBlock)block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://localhost:5000/toros/received/52081035ea1ec5890d000001"]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeCreateToro completionBlock:block toConnection:connection];
}


- (void)getAllTorosReceivedWithCompletionBlock:(OtoroConnectionCompletionBlock)block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://localhost:5000/toros/received/52081035ea1ec5890d000001"]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self addAPICall:OtoroConnectionAPITypeGetReceivedToro completionBlock:block toConnection:connection];
}


@end
