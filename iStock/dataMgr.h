//
//  dataMgr.h
//  iStock
//
//  Created by game-netease on 15/6/5.
//  Copyright (c) 2015年 McKeeLin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NN_STOCK_UPDATE @"StockUpdataNotificationName"


@interface RealtimeData : NSObject

@property NSString *code;

@property NSString *s1;

@property NSString *s2;

@property NSString *s3;

@property NSString *s4;

@property NSString *s5;

@property NSString *b1;

@property NSString *b2;

@property NSString *b3;

@property NSString *b4;

@property NSString *b5;

@property NSString *sc1;

@property NSString *sc2;

@property NSString *sc3;

@property NSString *sc4;

@property NSString *sc5;

@property NSString *bc1;

@property NSString *bc2;

@property NSString *bc3;

@property NSString *bc4;

@property NSString *bc5;

@property NSString *price;

@property NSString *sc;

@property NSString *bc;

@property NSString *yestodayEndPrice;

@property NSString *todayBeginPrice;

@property NSString *exchangedCount;

@property NSString *buyTotal;

@property NSString *sellTotal;

@property NSString *diffTotal;

@property NSString *currentCount;

@property NSString *exchangedRate;

@property NSString *earnPercentage;

@property NSString *myEarn;

@property CGFloat todayPer;

@property CGFloat myPer;

@property CGFloat max;

@property CGFloat min;

@property int maxb;

@property int maxs;

@property int cb;

@property int cs;

@end



@interface dataMgr : NSObject

@property NSString *code;

@property CGFloat myPrice;

@property CGFloat earnPercentage;

@property CGFloat myEarn;

@property CGFloat observeLP;

@property CGFloat observeHP;

@property NSInteger count;

@property int lastb;

@property int lasts;

@property int maxb;

@property int maxs;

@property RealtimeData *data;


@property CGFloat max;

@property CGFloat min;

- (void)getRealtimeData:(NSString*)code block:(void(^)(RealtimeData *data))block;

- (void)getRealtimeData;

@end
