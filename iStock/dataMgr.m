//
//  dataMgr.m
//  iStock
//
//  Created by game-netease on 15/6/5.
//  Copyright (c) 2015年 McKeeLin. All rights reserved.
//

/*
 http://qt.gtimg.cn/0000_0&q=sh600010
 http://qt.gtimg.cn/2487_1&q=sh600010,
 application/x-javascript
 
 v_sh600010="1~包钢股份~600010~6.48~6.50~6.48~5450568~2936484~2514084~6.48~15683~6.47~2829~6.46~6131~6.45~4314~6.44~1262~6.49~5220~6.50~16021~6.51~8401~6.52~9059~6.53~8193~15:00:01/6.48/3772/S/2447043/14901|14:59:56/6.49/3638/B/2358823/14898|14:59:46/6.49/1371/B/889301/14895|14:59:41/6.48/1570/S/1017768/14892|14:59:26/6.49/4626/B/3000091/14886|14:59:26/6.48/2531/S/1641664/14881~20150604150453~-0.02~-0.31~6.55~6.01~6.49/5446796/3465884971~5450568~346833~3.46~956.24~~6.55~6.01~8.31~1020.08~2109.93~5.47~7.15~5.85~";
 */

/*
 http://hq.stock.sohu.com/cn/776/cn_000776-1.html
 */

#import "dataMgr.h"
#import "AFNetworking.h"

AFHTTPRequestOperationManager *_manager;

@interface RealtimeData ()
{
}

@end



@implementation RealtimeData

- (id)init
{
    self = [super init];
    if( self ){
        _min = 0;
        _max = 0;
        _myPer = 0;
        _todayPer = 0;
        _maxb = 0;
        _maxs = 0;
        _cb = 0;
        _cs = 0;
    }
    return self;
}

@end



@interface dataMgr ()<NSURLConnectionDelegate>
{
    NSMutableData *_receivedData;
}

@end

@implementation dataMgr

- (id)init
{
    self = [super init];
    if( self ){
        _receivedData = [[NSMutableData alloc] initWithCapacity:0];
        _min = 0;
        _max = 0;
        _lastb = 0;
        _lasts = 0;
        _maxb = 0;
        _maxs = 0;
    }
    return self;
}

- (void)getRealtimeData:(NSString *)code block:(void (^)(RealtimeData *))block
{
    NSString *urlString = [NSString stringWithFormat:@"http://qt.gtimg.cn/0000_0&q=%@", code];
    NSError *error;
//    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"application/x-javascript" forHTTPHeaderField:@"Content-Type"];
    
    if( !_manager ){
        _manager = [[AFHTTPRequestOperationManager alloc] init];
        NSSet *set = _manager.responseSerializer.acceptableContentTypes;
        set = [set setByAddingObject:@"application/x-javascript"];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/x-javascript"];
        NSSet *newSet = _manager.responseSerializer.acceptableContentTypes;
    }
    AFHTTPRequestOperation *operation = [_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id result){
        NSString *response = (NSString*)result;
        response = [response stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        response = [response stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *a1 = [response componentsSeparatedByString:@"="];
        NSString *s = a1.lastObject;
        NSArray *a2 = [s componentsSeparatedByString:@"~"];
        RealtimeData *data = [[RealtimeData alloc] init];
        data.price = [a2 objectAtIndex:3];
        data.yestodayEndPrice = [a2 objectAtIndex:4];
        data.todayBeginPrice = [a2 objectAtIndex:5];
        data.exchangedCount = [a2 objectAtIndex:6];
        data.buyTotal = [a2 objectAtIndex:7];
        data.sellTotal = [a2 objectAtIndex:8];
        data.b1 = [a2 objectAtIndex:9];
        data.bc1 = [a2 objectAtIndex:10];
        data.b2 = [a2 objectAtIndex:11];
        data.bc2 = [a2 objectAtIndex:12];
        data.b3 = [a2 objectAtIndex:13];
        data.bc3 = [a2 objectAtIndex:14];
        data.b4 = [a2 objectAtIndex:15];
        data.bc4 = [a2 objectAtIndex:16];
        data.b5 = [a2 objectAtIndex:17];
        data.s1 = [a2 objectAtIndex:18];
        data.sc1 = [a2 objectAtIndex:19];
        data.s2 = [a2 objectAtIndex:20];
        data.sc2 = [a2 objectAtIndex:21];
        data.s3 = [a2 objectAtIndex:22];
        data.sc3 = [a2 objectAtIndex:23];
        data.s4 = [a2 objectAtIndex:24];
        data.sc4 = [a2 objectAtIndex:25];
        data.s5 = [a2 objectAtIndex:26];
        data.sc5 = [a2 objectAtIndex:27];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%@", error);
    }];
    [_manager.operationQueue addOperation:operation];
}

- (void)getRealtimeData
{
    NSString *urlString = [NSString stringWithFormat:@"http://qt.gtimg.cn/0000_0&q=%@", _code];
    NSError *error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"application/x-javascript" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s, %@", __func__, error.localizedDescription);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receivedData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *result = [[NSString alloc] initWithData:_receivedData encoding:gbkEncoding];
    NSString *response = result;
    response = [response stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    response = [response stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSArray *a1 = [response componentsSeparatedByString:@"="];
    NSString *s = a1.lastObject;
    NSArray *a2 = [s componentsSeparatedByString:@"~"];
    RealtimeData *data = [[RealtimeData alloc] init];
    data.price = [a2 objectAtIndex:3];
    if( data.price && data.price.length > 0 ){
        data.yestodayEndPrice = [a2 objectAtIndex:4];
        data.todayBeginPrice = [a2 objectAtIndex:5];
        data.exchangedCount = [a2 objectAtIndex:6];
        data.buyTotal = [a2 objectAtIndex:7];
        data.sellTotal = [a2 objectAtIndex:8];
        
        int buy = data.buyTotal.intValue;
        if( _lastb > 0 ){
            int diffb = buy - _lastb;
            if( diffb > _maxb ) _maxb = diffb;
            data.maxb = _maxb;
            data.cb = diffb;
        }
        _lastb = buy;
        
        int sell = data.sellTotal.intValue;
        if( _lasts > 0 ){
            int diffs = sell - _lasts;
            if( diffs > _maxs ) _maxs = diffs;
            data.maxs = _maxs;
            data.cs = diffs;
        }
        _lasts = sell;
        
        data.diffTotal = [NSString stringWithFormat:@"%d", buy - sell];
        data.b1 = [a2 objectAtIndex:9];
        data.bc1 = [a2 objectAtIndex:10];
        data.b2 = [a2 objectAtIndex:11];
        data.bc2 = [a2 objectAtIndex:12];
        data.b3 = [a2 objectAtIndex:13];
        data.bc3 = [a2 objectAtIndex:14];
        data.b4 = [a2 objectAtIndex:15];
        data.bc4 = [a2 objectAtIndex:16];
        data.b5 = [a2 objectAtIndex:17];
        data.bc5 = [a2 objectAtIndex:18];
        data.s1 = [a2 objectAtIndex:19];
        data.sc1 = [a2 objectAtIndex:20];
        data.s2 = [a2 objectAtIndex:21];
        data.sc2 = [a2 objectAtIndex:22];
        data.s3 = [a2 objectAtIndex:23];
        data.sc3 = [a2 objectAtIndex:24];
        data.s4 = [a2 objectAtIndex:25];
        data.sc4 = [a2 objectAtIndex:26];
        data.s5 = [a2 objectAtIndex:27];
        data.sc5 = [a2 objectAtIndex:28];
        data.exchangedRate = [a2 objectAtIndex:38];
        data.code = _code;
        if( _myPrice > 0 && data.price ){
            _earnPercentage = (data.price.floatValue * 100 - _myPrice * 100) - _myPrice * 100;
            _myEarn = (data.price.floatValue - _myPrice) * _count;
            data.earnPercentage = [NSString stringWithFormat:@"%02f", _earnPercentage];
            data.myEarn = [NSString stringWithFormat:@"%02f", _myEarn];
        }
        else{
            data.earnPercentage = @"0.00";
            data.myEarn = @"0.00";
        }
        if( data.price.floatValue > _max ) _max = data.price.floatValue;
        if( data.price.floatValue < _min ) _min = data.price.floatValue;
        if( _min == 0 ){
            _min = data.price.floatValue;
        }
        data.min = _min;
        data.max = _max;
        if( data.price.floatValue > 0 ){
            data.todayPer = ((data.price.floatValue - data.yestodayEndPrice.floatValue) / data.yestodayEndPrice.floatValue) * 100;
            data.myPer = ((data.price.floatValue - _myPrice) / _myPrice) * 100;
        }
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
        [userInfo setValue:data forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NN_STOCK_UPDATE object:nil userInfo:userInfo];
    }
}

@end
