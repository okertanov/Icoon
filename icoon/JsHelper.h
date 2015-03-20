//
//  JsHelper.h
//  icoon
//
//  Created by Oleg Kertanov on 20/03/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScript.h>
#import <JavaScriptCore/JSContextRef.h>
#import <WebKit/WebScriptObject.h>

@interface JsHelper : NSObject

+(JSValueRef)makeJsArray:(NSArray*)array withContext:(JSContextRef)context;
+(JSValueRef)makeJsString:(id)object withContext:(JSContextRef)context;
+(NSArray*)makeNsArray:(WebScriptObject*)wsObj withContext:(JSContextRef)context;

@end
