//
//  LXKWKWebView.m
//  Icoon Screen Saver
//
//  Created by Oleg Kertanov on 2/12/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import "LXKWKWebView.h"

@implementation LXKWKWebView

- (instancetype)initWithFrame:(NSRect)frameRect {
    _configuration = [[WKWebViewConfiguration alloc] init];
    
    self = [super initWithFrame:frameRect configuration:_configuration];
    
    if (self) {
        [self setNavigationDelegate:self];
        [self setUIDelegate:self];
        [self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [self setAutoresizesSubviews:YES];
        
        NSColor *color = [NSColor colorWithCalibratedWhite:0.0 alpha:1.0];
        [[self layer] setBackgroundColor:color.CGColor];
    }
    
    return self;
}

- (void)dealloc {
    [self stopLoading];
}

- (void)load:(NSString*)url {
    NSURL* nsUrl = [NSURL URLWithString:url];
    NSURLRequest* nsRequest = [NSURLRequest requestWithURL:nsUrl];
    [self loadRequest:nsRequest];
}

- (void)reload {
    [self reload:nil];
}

#pragma mark WK Web View Delegates

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation: (WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFinishNavigation: (WKNavigation *)navigation{
}

-(void)webView:(WKWebView *)webView didFailNavigation: (WKNavigation *)navigation withError:(NSError *)error {
}

- (BOOL)acceptsFirstResponder {
    return NO;
}

- (BOOL)resignFirstResponder {
    return YES;
}

@end
