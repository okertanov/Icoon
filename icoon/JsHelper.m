//
//  JsHelper.m
//  icoon
//
//  Created by Oleg Kertanov on 20/03/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import "JsHelper.h"

@implementation JsHelper

+(JSValueRef)makeJsArray:(NSArray*)array withContext:(JSContextRef)context {
    JSValueRef jsArray;
    
    NSUInteger i = 0;
    NSUInteger pcount = [array count];
    JSValueRef jsArgs[pcount];
    
    for (id v in array) {
        jsArgs[i++] = [self makeJsString:v withContext:context];
    }
    jsArray = JSObjectMakeArray(context, pcount, jsArgs, NULL);
    
    return jsArray;
}

+(JSValueRef)makeJsString:(id)object withContext:(JSContextRef)context {
    JSValueRef jsStr = nil;
    
    JSStringRef jstr = JSStringCreateWithUTF8CString([object UTF8String]);
    jsStr = JSValueMakeString(context, jstr);
    JSStringRelease(jstr);
    
    return jsStr;
}

+(NSArray*)makeNsArray:(WebScriptObject*)wsObj withContext:(JSContextRef)context {
    NSMutableArray* nsArray = [[NSMutableArray alloc] init];
    
    NSUInteger elementsCount = [[wsObj valueForKey:@"length"] integerValue];
    for (NSUInteger i = 0; i < elementsCount; i++) {
        NSString *item = [wsObj webScriptValueAtIndex:(unsigned)i];
        if ([item isKindOfClass:[NSString class]]) {
            [nsArray addObject:item];
        }
    }
    
    return [nsArray copy];
}

@end
