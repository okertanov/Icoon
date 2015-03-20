//
//  JsObject.m
//  icoon
//
//  Created by Oleg Kertanov on 3/19/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import "JsModule.h"

@implementation JsModule

@synthesize module;
@synthesize scriptingBridge;

-(instancetype)initWithScriptingBridge:(id<LXKJsScriptingBridgeProtocol>)bridge {
    self = [super init];
    
    if (self) {
        self.scriptingBridge = bridge;
    }
    
    return self;
}

-(void)dealloc {
}

+(BOOL)isSelectorExcludedFromWebScript:(SEL)selector {
    return NO;
}

+(BOOL)isKeyExcludedFromWebScript:(const char*)name {
    return NO;
}

+(NSString*)webScriptNameForSelector:(SEL)selector {
    NSString* webScriptSelectorName = NSStringFromSelector(selector);
    
    return webScriptSelectorName;
}

+(NSString *)webScriptNameForKey:(const char *)name {
    NSString* webScriptKeyName = [NSString stringWithUTF8String:name];
    
    return webScriptKeyName;
}

@end
