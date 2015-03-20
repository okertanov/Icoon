//
//  LXKWebView.h
//  Icoon Screen Saver
//
//  Created by Oleg Kertanov on 09/02/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface LXKWebView : WebView

-(void)load:(NSString*)url;
-(void)reload;
    
@end
