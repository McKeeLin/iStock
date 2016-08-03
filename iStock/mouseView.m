//
//  mouseView.m
//  iStock
//
//  Created by McKee on 15/7/1.
//  Copyright (c) 2015年 McKeeLin. All rights reserved.
//

#import "mouseView.h"

@implementation mouseView


- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self)
    {
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)viewDidMoveToSuperview
{
    [super viewDidMoveToSuperview];
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:YES];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    NSLog(@"...%f,%f,%f", theEvent.deltaX, theEvent.deltaY, theEvent.deltaZ);
    NSApplication *app = [NSApplication sharedApplication];
    NSArray *windows = app.windows;
    NSWindow *window = windows.firstObject;
    CGFloat alpha = window.alphaValue;
    alpha += theEvent.deltaY/5;
    if( alpha < 0.05 ) alpha = 0.05;
    if( alpha > 0.15 ) alpha = 0.15;
    window.alphaValue = alpha;
    NSLog(@"-----------%f", alpha);
}


@end
