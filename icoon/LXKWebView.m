//
//  LXKWebView.m
//  Icoon Screen Saver
//
//  Created by Oleg Kertanov on 09/02/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import "LXKWebView.h"

@implementation LXKWebView

- (instancetype)initWithFrame:(NSRect)frameRect
                    frameName:(NSString *)frameName
                    groupName:(NSString *)groupName {
    self = [super initWithFrame:frameRect frameName:frameName groupName:groupName];
    
    if (self) {
        [self setFrameLoadDelegate:self];
        [self setPolicyDelegate:self];
        [self setUIDelegate:self];
        [self setEditingDelegate:self];
        [self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
        [self setAutoresizesSubviews:YES];
        [self setDrawsBackground:NO];
        [self setShouldUpdateWhileOffscreen:YES];
        
        NSColor *color = [NSColor colorWithCalibratedWhite:0.0 alpha:1.0];
        [[self layer] setBackgroundColor:color.CGColor];
    }
    
    return self;
}

- (void)dealloc {
    [self setFrameLoadDelegate:nil];
    [self setPolicyDelegate:nil];
    [self setUIDelegate:nil];
    [self setEditingDelegate:nil];
    [self close];
}

#pragma mark Web View Delegates

- (void)webView:(WebView *)webView
                decidePolicyForNewWindowAction:(NSDictionary *)actionInformation
                request:(NSURLRequest *)request
                newFrameName:(NSString *)frameName
                decisionListener:(id < WebPolicyDecisionListener >)listener {
    // Don't open new windows.
    [listener ignore];
}

- (void)webView:(WebView *)webView didFinishLoadForFrame:(WebFrame *)frame {
    [self resignFirstResponder];
    [[[self mainFrame] frameView] setAllowsScrolling:NO];
}

- (NSResponder *)webViewFirstResponder:(WebView *)sender {
    return self;
}

- (void)webViewClose:(WebView *)sender {
    return;
}

- (BOOL)webViewIsResizable:(WebView *)sender {
    return NO;
}

- (BOOL)webViewAreToolbarsVisible:(WebView *)sender {
    return NO;
}

- (BOOL)webViewIsStatusBarVisible:(WebView *)sender {
    return NO;
}

- (void)webViewRunModal:(WebView *)sender {
    return;
}

- (void)webViewShow:(WebView *)sender {
    return;
}

- (void)webViewUnfocus:(WebView *)sender {
    return;
}

- (NSView *)hitTest:(NSPoint)aPoint {
    return self;
}

- (void)keyDown:(NSEvent *)theEvent {
    return;
}

- (void)keyUp:(NSEvent *)theEvent {
    return;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)resignFirstResponder {
    return NO;
}

@end
