//
//  LXKWKWebView.h
//  Icoon Screen Saver
//
//  Created by Oleg Kertanov on 2/12/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface LXKWKWebView : WKWebView<WKNavigationDelegate, WKUIDelegate> {
    @private
    //
    // Internals
    //
    WKWebViewConfiguration* _configuration;
}

- (void)load:(NSString*)url;
- (void)reload;

@end
