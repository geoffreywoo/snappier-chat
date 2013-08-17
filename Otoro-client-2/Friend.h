//
//  Friend.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic) Boolean preferred;
@property (nonatomic) Boolean selected;

- (id)initWith:(NSDictionary *)dict;

@end
