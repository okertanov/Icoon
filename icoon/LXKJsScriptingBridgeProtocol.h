//
//  LXKJsScriptingBridgeProtocol.h
//  icoon
//
//  Created by Oleg Kertanov on 3/19/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScript.h>
#import <JavaScriptCore/JSContextRef.h>
#import <WebKit/WebScriptObject.h>

@protocol LXKJsScriptingBridgeProtocol <NSObject>

-(JSContextRef)getJsContext;

@end
