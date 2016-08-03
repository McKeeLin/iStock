//
//  mySQL.h
//  iStock
//
//  Created by McKee on 15/8/20.
//  Copyright (c) 2015年 McKeeLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mySQL : NSObject

@property NSString *host;

@property unsigned int  port;

@property NSString *user;

@property NSString *password;

@property NSString *database;


- (BOOL)connentTo:(NSString*)host port:(int)port user:(NSString*)user password:(NSString*)password database:(NSString*)database;

- (BOOL)connect;

- (void)close;

- (BOOL)execute:(NSString*)sql;

@end
