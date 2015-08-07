//
//  AppDelegate.m
//  iStock
//
//  Created by game-netease on 15/6/4.
//  Copyright (c) 2015年 McKeeLin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSApplication *app = [NSApplication sharedApplication];
    NSArray *windows = app.windows;
    NSWindow *window = windows.firstObject;
    [window setMovableByWindowBackground:YES];
    [window setOpaque:NO];
    window.backgroundColor = [NSColor colorWithCalibratedRed:1 green:1 blue:0 alpha:0.021];
    window.alphaValue = 0.119;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
