//
//  LXKJsScriptingBridge.m
//  icoon
//
//  Created by Oleg Kertanov on 3/19/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import "LXKJsScriptingBridge.h"
#import "JsSystem.h"
#import "JsApplications.h"

@implementation LXKJsScriptingBridge

@synthesize module;
@synthesize system;
@synthesize applications;

-(instancetype)initWithContext:(JSContextRef)context {
    self = [super init];
    
    if (self) {
        jsContext = context;
        JSGlobalContextRetain((JSGlobalContextRef)jsContext);
        
        //
        // Exports registration
        //
        self.module = NSStringFromClass([self class]);
        self.system = [[JsSystem alloc] initWithScriptingBridge:self];
        self.applications = [[JsApplications alloc] initWithScriptingBridge:self];
    }
    
    return self;
}

-(void)dealloc {
    if (jsContext != nil) {
        JSGlobalContextRelease((JSGlobalContextRef)jsContext);
    }
    
    self.system = nil;
    self.applications = nil;
}

-(JSContextRef)getJsContext {
    return jsContext;
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
