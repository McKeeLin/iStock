//
//  mySQL.m
//  iStock
//
//  Created by McKee on 15/8/20.
//  Copyright (c) 2015年 McKeeLin. All rights reserved.
//

#import "mySQL.h"
#import <mysql.h>

@interface mySQL ()
{
    MYSQL _mysql;
}

@end

@implementation mySQL

- (BOOL)connentTo:(NSString *)host port:(int)port user:(NSString *)user password:(NSString *)password database:(NSString*)database
{
    _host = host;
    _port = port;
    _user = user;
    _password = password;
    _database = database;
    return  [self connect];
}

- (BOOL)connect
{
    if( !mysql_init(&_mysql) )
    {
        NSLog(@"init mysql failed");
        return NO;
    }
    
    MYSQL *result = mysql_real_connect(&_mysql, [_host cStringUsingEncoding:NSUTF8StringEncoding], [_user cStringUsingEncoding:NSUTF8StringEncoding], [_password cStringUsingEncoding:NSUTF8StringEncoding], [_database cStringUsingEncoding:NSUTF8StringEncoding], _port, NULL, 0);
    if( result ){
        NSLog(@"connect to %@:%d succeeded", _host, _port);
        return YES;
    }
    else{
        NSLog(@"connect to %@:%d failed, error:%@", _host, _port, [self getError]);
        return 0;
    }
}

- (void)close
{
    mysql_close(&_mysql);
}

- (BOOL)execute:(NSString *)sql
{
    int result = mysql_query(&_mysql, [sql cStringUsingEncoding:NSUTF8StringEncoding] );
    if( result != 0 ){
        NSLog(@"query failed: %@, error:%@", sql, [self getError]);
        return NO;
    }
    else{
        MYSQL_RES *res = mysql_store_result(&_mysql);
        if( res ){
            int fieldCnt = mysql_num_fields(res);
            int rowCnt = (int)mysql_num_rows(res);
            NSLog(@"query succeeded: %@\n field count:%d, row count:%d", sql, fieldCnt, rowCnt);
            return YES;
        }
        else{
            return NO;
        }
    }
    
}

- (NSString*)getError
{
    return [NSString stringWithUTF8String:mysql_error(&_mysql)];
}


@end
