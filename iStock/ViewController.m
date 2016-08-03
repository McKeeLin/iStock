//
//  ViewController.m
//  iStock
//
//  Created by game-netease on 15/6/4.
//  Copyright (c) 2015年 McKeeLin. All rights reserved.
//
//  http://qt.gtimg.cn/q=s_sh600010

#import "ViewController.h"
#import "dataMgr.h"
#import "mySQL.h"

// 6277
// 942
// test


@interface ViewController ()
{
    mySQL *_mySQL;
    NSView *_anchor;
    
}


@property IBOutlet NSTextField *s1;

@property IBOutlet NSTextField *s2;

@property IBOutlet NSTextField *s3;

@property IBOutlet NSTextField *s4;

@property IBOutlet NSTextField *s5;

@property IBOutlet NSTextField *p;

@property IBOutlet NSTextField *b1;

@property IBOutlet NSTextField *b2;

@property IBOutlet NSTextField *b3;

@property IBOutlet NSTextField *b4;

@property IBOutlet NSTextField *b5;

@property IBOutlet NSTextField *sc1;

@property IBOutlet NSTextField *sc2;

@property IBOutlet NSTextField *sc3;

@property IBOutlet NSTextField *sc4;

@property IBOutlet NSTextField *sc5;

@property IBOutlet NSTextField *ep;

@property IBOutlet NSTextField *bc1;

@property IBOutlet NSTextField *bc2;

@property IBOutlet NSTextField *bc3;

@property IBOutlet NSTextField *bc4;

@property IBOutlet NSTextField *bc5;


@property IBOutlet NSTextField *s;

@property IBOutlet NSTextField *b;

@property IBOutlet NSTextField *t;

@property IBOutlet NSTextField *ye;

@property IBOutlet NSTextField *ts;

@property IBOutlet NSTextField *tmax;

@property IBOutlet NSTextField *tmin;

@property IBOutlet NSView *titlebar;

@property IBOutlet NSTextField *bns;

@property IBOutlet NSTextField *shTf;

@property IBOutlet NSTextField *szTf;

@property IBOutlet NSTextField *cybTf;

@property IBOutlet NSTextField *perTf;

@property IBOutlet NSTextField *exchangeTf;

@property IBOutlet NSTextField *mxpTf;

@property IBOutlet NSTextField *mnpTf;

@property NSString *sh;

@property NSString *sz;

@property NSString *cyb;

@property dataMgr *dm601668;

@property dataMgr *dm2;

@property dataMgr *dmSH;

@property dataMgr *dmSZ;

@property dataMgr *dmCYB;

@property dataMgr *dm3;

@property dataMgr *dm4;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    _mySQL = [[mySQL alloc] init];
    _mySQL.host = @"127.0.0.1";
    _mySQL.port = 3306;
    _mySQL.user = @"root";
    _mySQL.password = @"";
    _mySQL.database = @"new_schema";
    if( [_mySQL connect] )
    {
        [_mySQL execute:@"select * from new_schema.t1"];
    }
    */

    // Do any additional setup after loading the view.
    /*
     zgjz   601668  7.00
     hdxx   300170
     zjdr   600113
     gfzq   000776  22.85
     zggh   601111  11.10
     hygf   000861  16.47
     hszs   300208  44.00
     zghd   601985  7.86
     jnfd   601016  11.22
     */
    _dm2 = [[dataMgr alloc] init];
    _dm2.code = @"sz300170";
    _dm2.myPrice = 13.56;
    _dm2.observeLP = 0;
    _dm2.observeHP = 0;
    _dmSH = [[dataMgr alloc] init];
    _dmSH.code = @"sh000001";
    _dmSZ = [[dataMgr alloc] init];
    _dmSZ.code = @"sz399001";
    _dmCYB = [[dataMgr alloc] init];
    _dmCYB.code = @"sz399006";
    _dm3 = [[dataMgr alloc] init];
    _dm3.code = @"sh601016";
    _dm3.myPrice = 11.22;
    _dm4 = [[dataMgr alloc] init];

    
    self.view.layer.backgroundColor = [NSColor clearColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateNotification:) name:NN_STOCK_UPDATE object:nil];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];

    _anchor = [[NSView alloc] initWithFrame:CGRectZero];
    _anchor.layer.cornerRadius = 5;
    _anchor.layer.backgroundColor = [NSColor colorWithRed:1 green:0 blue:0 alpha:0.5].CGColor;
    [self.view addSubview:_anchor];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)viewDidLayout
{
    [super viewDidLayout];
    _anchor.frame = CGRectMake(0,0,10,10);
}

- (void)onTimer:(NSTimer*)timer
{
    NSDateComponents *componets = [self currentDateComponents];
    if( componets.hour < 9 ) return;
    if( componets.hour == 9 && componets.minute < 15 ) return;
    if( componets.hour == 11 && componets.minute > 30 ) return;
    if( componets.hour > 11 && componets.hour < 13 ) return;
    if( componets.hour == 15 && componets.minute > 1 ) return;
//    if( componets.hour > 15 ) return;
    
    [_dm2 getRealtimeData];
    [_dm3 getRealtimeData];
    [_dmSH getRealtimeData];
    [_dmSZ getRealtimeData];
    [_dmCYB getRealtimeData];
}

-(NSDateComponents*)currentDateComponents
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:today];
}



- (void)onUpdateNotification:(NSNotification*)notification
{
    RealtimeData *data = [notification.userInfo objectForKey:@"data"];
    if( [data.code isEqualToString:@"sh000001"] ){
        NSLog(@"%@ \t%.02f", data.price, data.todayPer);
        self.sh = [NSString stringWithFormat:@"sh:%@(%.02f)", data.price, data.todayPer];
        _shTf.stringValue = self.sh;
    }
    else if( [data.code isEqualToString:@"sz399001"] )
    {
        self.sz = [NSString stringWithFormat:@"sz:%@(%.02f)", data.price, data.todayPer];
        _szTf.stringValue = self.sz;
    }
    else if( [data.code isEqualToString:@"sz399006"] )
    {
        self.cyb = [NSString stringWithFormat:@"cyb:%@(%.02f)", data.price, data.todayPer];
        _cybTf.stringValue = self.cyb;
    }
    else {
        if( ![data.code isEqualToString:_dm3.code] ){
            NSLog(@"%@ \t%.02f\t%.02f\t\t%@s(%d,%d) b(%d,%d)\t\t\t%@\t\t%@\t\t%@", data.price, data.max, data.min, data.diffTotal, data.maxs, data.cs, data.maxb, data.cb, data.exchangedRate, [self valueString:data.todayPer], [self valueString:data.myPer]);
        }
    }
    
    if( [data.code isEqualToString:_dm2.code] ){
        [_s5 setStringValue:data.s5];
        [_s4 setStringValue:data.s4];
        [_s3 setStringValue:data.s3];
        [_s2 setStringValue:data.s2];
        [_s1 setStringValue:data.s1];
        [_p setStringValue:data.price];
        [_b1 setStringValue:data.b1];
        [_b2 setStringValue:data.b2];
        [_b3 setStringValue:data.b3];
        [_b4 setStringValue:data.b4];
        [_b5 setStringValue:data.b5];
        
        [_sc5 setStringValue:data.sc5];
        [_sc4 setStringValue:data.sc4];
        [_sc3 setStringValue:data.sc3];
        [_sc2 setStringValue:data.sc2];
        [_sc1 setStringValue:data.sc1];
        [_bc1 setStringValue:data.bc1];
        [_bc2 setStringValue:data.bc2];
        [_bc3 setStringValue:data.bc3];
        [_bc4 setStringValue:data.bc4];
        [_bc5 setStringValue:data.bc5];
        
        [_s setStringValue:data.sellTotal];
        [_t setStringValue:data.exchangedCount];
        [_b setStringValue:data.buyTotal];
        
        [_ye setStringValue:data.yestodayEndPrice];
        [_ts setStringValue:data.todayBeginPrice];
        [_perTf setStringValue:[NSString stringWithFormat:@"%.2f", data.myPer]];
        [_exchangeTf setStringValue:data.exchangedRate];
        [_mxpTf setStringValue:[NSString stringWithFormat:@"%.2f", data.max]];
        [_mnpTf setStringValue:[NSString stringWithFormat:@"%.2f", data.min]];
        NSString *bns = [NSString stringWithFormat:@"%@s(%d,%d) b(%d,%d)",data.diffTotal, data.maxs, data.cs, data.maxb, data.cb];
        [_bns setStringValue:bns];
//        [_ep setStringValue:[NSString stringWithFormat:@"%f", data.earnPercentage]];
        int st = [data.sc1 intValue];
        st += [data.sc2 intValue];
        st += data.sc3.intValue;
        st += data.sc4.intValue;
        st += data.sc5.intValue;
        
        int bt = data.bc1.intValue;
        bt += data.bc2.intValue;
        bt += data.bc3.intValue;
        bt += data.bc4.intValue;
        bt += data.bc5.intValue;
        bt -= st;
        [_ep setStringValue:[NSString stringWithFormat:@"%d", bt]];
        if( _dm2.observeLP != 0 && data.price.floatValue <= _dm2.observeLP ){
            [NSApp requestUserAttention:0];
        }
        
        if( _dm2.observeHP != 0 && data.price.floatValue >= _dm2.observeHP ){
//            [NSApp dockTile].showsApplicationBadge = YES;
            [[NSApp dockTile] setBadgeLabel:@"1"];
        }
        else{
//            [NSApp dockTile].showsApplicationBadge = NO;
            [[NSApp dockTile] setBadgeLabel:nil];
        }
        
        if( [_tmax.stringValue isEqualToString:@"max"] )
        {
            CGFloat tmax = data.yestodayEndPrice.floatValue * 1.1;
            CGFloat tmin = data.yestodayEndPrice.floatValue * 0.9;
            _tmax.stringValue = [NSString stringWithFormat:@"%.2f", tmax];
            _tmin.stringValue = [NSString stringWithFormat:@"%.2f", tmin];
        }
    }
}

- (NSString*)valueString:(CGFloat)value
{
    NSString *tempString = [NSString stringWithFormat:@"%.02f", value];
    CGFloat tempValue = tempString.floatValue * 100;
    if( value < 0 )
    {
        return [NSString stringWithFormat:@"0%d", (int)tempValue];
    }
    else{
        return [NSString stringWithFormat:@"%d", (int)tempValue];
    }
    
}


@end
