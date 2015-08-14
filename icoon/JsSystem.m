//
//  JsSystem.m
//  icoon
//
//  Created by Oleg Kertanov on 3/20/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#include <sys/utsname.h>
#import "JsHelper.h"
#import "JsSystem.h"

@interface JsSystem()

@property (strong, nonatomic) NSMutableArray* runningTasks;

-(void)dispatchResult:(BOOL)result withContext:(JSContextRef)context forCallback:(WebScriptObject*)callback;

@end

@implementation JsSystem

@synthesize os;
@synthesize home;
@synthesize logo;
@synthesize uptime;
@synthesize hostname;
@synthesize username;
@synthesize machine;
@synthesize kernel;
@synthesize locale;

-(instancetype)initWithScriptingBridge:(id<LXKJsScriptingBridgeProtocol>)bridge {
    self = [super initWithScriptingBridge:bridge];
    
    if (self) {
        self.module = NSStringFromClass([self class]);
        
        // Misc init
        self.runningTasks = [[NSMutableArray alloc] init];
        
        // os
        NSString* osVersion = [[NSProcessInfo processInfo] operatingSystemVersionString];
        self.os = [NSString stringWithFormat:@"%@ %@", @"Mac OS X", osVersion];
        // home
        self.home = NSHomeDirectory();
        // logo
        self.logo = @"\uF8FF";
        // uptime
        NSTimeInterval systemUptime = [[NSProcessInfo processInfo] systemUptime];
        int uptimeDays = fabs(systemUptime / (60 * 60 * 24));
        self.uptime = [NSString stringWithFormat:@"%d", uptimeDays];
        // hostname
        self.hostname = [[NSProcessInfo processInfo] hostName];
        // username
        self.username = NSUserName();
        // locale
        NSLocale* currLocale = [NSLocale currentLocale];
        self.locale = [currLocale localeIdentifier];
        // machine
        struct utsname uts;
        int rc = uname(&uts);
        if (rc == 0) {
            self.machine = [NSString stringWithUTF8String:uts.machine];
            self.kernel = [NSString stringWithUTF8String:uts.version];
        }
    }
    
    return self;
}

-(void)dealloc {
    if (self.runningTasks != nil && [self.runningTasks count] > 0) {
        for (id task in self.runningTasks) {
            if (task != nil) {
                [task terminate];
            }
        }
        
        [self.runningTasks removeAllObjects];
    }
    
    self.runningTasks = nil;
}

-(void)execute:(NSString*)executable
            withArguments:(WebScriptObject*)arguments
            complete:(WebScriptObject*)completeCb {
    
    JSContextRef jsContext = [self.scriptingBridge getJsContext];
    NSArray* __block nsArguments = [JsHelper makeNsArray:arguments withContext:jsContext];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSLog(@"Launching app %@...", executable);
        BOOL executed = NO;
        @try {
            NSTask* task = [[NSTask alloc] init];
            NSPipe* outPipe = [NSPipe pipe];
            NSPipe* errPipe = [NSPipe pipe];
            [task setStandardOutput:outPipe];
            [task setStandardError:errPipe];
            [task setLaunchPath:executable];
            [task setArguments:nsArguments];
            [task launch];
            [self.runningTasks addObject:task];
            executed = YES;
        }
        @catch(NSException *ex) {
            NSLog(@"Error launching app %@: %@: %@", executable, ex.name, ex.reason);
        }
        @finally {
            [self dispatchResult:executed
                     withContext:jsContext
                     forCallback:completeCb];
        }
        NSLog(@"Completed launching app %@.", executable);
    });
}

-(void)dispatchResult:(BOOL)result withContext:(JSContextRef)context forCallback:(WebScriptObject*)callback {
    if (callback == nil)
        return;
    
    if ([callback isKindOfClass:[WebUndefined class]])
        return;
    
    JSObjectRef cbFn = [callback JSObject];
    JSValueProtect(context, cbFn);
    
    if (JSObjectIsFunction(context, cbFn)) {
        JSValueRef jsArgs[] = { JSValueMakeBoolean(context, result) };
        JSValueRef __unused ret = JSObjectCallAsFunction(context, cbFn, NULL, 1, jsArgs, NULL);
    }
    
    JSValueUnprotect(context, cbFn);
    cbFn = nil;
}

+(NSString*)webScriptNameForSelector:(SEL)selector {
    NSString* __unused webScriptSelectorName = NSStringFromSelector(selector);
    
    if (selector == @selector(execute:withArguments:complete:)) {
        return @"execute";
    }
    
    return [super webScriptNameForSelector:selector];
}

+(NSString *)webScriptNameForKey:(const char *)name {
    NSString* __unused webScriptKeyName = [NSString stringWithUTF8String:name];
    
    return [super webScriptNameForKey:name];
}

@end
