//
//  JsApplications.m
//  icoon
//
//  Created by Oleg Kertanov on 3/19/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import "JsApplications.h"

@interface JsApplications()

@property (strong, atomic) NSMetadataQuery* metadataQuery;
@property (strong, atomic) dispatch_semaphore_t querySemaphore;

-(void)dispatchResult:(NSArray*)result withContext:(JSContextRef)context forCallback:(WebScriptObject*)callback;

@end

@implementation JsApplications

@synthesize module;

-(instancetype)initWithScriptingBridge:(id<LXKJsScriptingBridgeProtocol>)bridge {
    self = [super initWithScriptingBridge:bridge];
    
    if (self) {
        self.module = NSStringFromClass([self class]);
        
        self.metadataQuery = [[NSMetadataQuery alloc] init];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryDidStartGathering:)
                                                     name:NSMetadataQueryDidStartGatheringNotification
                                                   object:self.metadataQuery];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryDidUpdateGathering:)
                                                     name:NSMetadataQueryDidUpdateNotification
                                                   object:self.metadataQuery];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryGatheringProgress:)
                                                     name:NSMetadataQueryGatheringProgressNotification
                                                   object:self.metadataQuery];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryDidFinishGathering:)
                                                     name:NSMetadataQueryDidFinishGatheringNotification
                                                   object:self.metadataQuery];
        
        self.querySemaphore = dispatch_semaphore_create(0);
    }
    
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidStartGatheringNotification
                                                  object:self.metadataQuery];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidUpdateNotification
                                                  object:self.metadataQuery];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryGatheringProgressNotification
                                                  object:self.metadataQuery];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:self.metadataQuery];
    
    if (self.metadataQuery != nil) {
        [self.metadataQuery disableUpdates];
        [self.metadataQuery stopQuery];
        self.metadataQuery = nil;
    }
    
    self.querySemaphore = 0;
}

-(void)all:(WebScriptObject*)completeCb {
    [self startQueryApplications:[self.scriptingBridge getJsContext] withCallback:completeCb];
}

-(void)startQueryApplications:(JSContextRef)context withCallback:(WebScriptObject*)completeCb  {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kMDItemKind == 'Application'"];
    [self.metadataQuery disableUpdates];
    [self.metadataQuery stopQuery];
    [self.metadataQuery setPredicate:predicate];
    // TODO: searchScopes
    
    __block BOOL startedQuery = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.metadataQuery enableUpdates];
        startedQuery = [self.metadataQuery startQuery];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        const int timeoutInSecs = 5;
        dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeoutInSecs * NSEC_PER_SEC));
        BOOL __unused timedout = dispatch_semaphore_wait(self.querySemaphore, timeout);
        [self stopQueryApplications:context withCallback:completeCb];
    });
}

-(void)stopQueryApplications:(JSContextRef)context withCallback:(WebScriptObject*)completeCb {
    [self.metadataQuery disableUpdates];
    [self.metadataQuery stopQuery];
    
    NSMutableArray* mapps = [[NSMutableArray alloc] init];

    NSUInteger resultCount = [self.metadataQuery resultCount];
    if (resultCount > 0) {
        NSLog(@">>> Found apps: %u", (unsigned int)resultCount);
        
        [self.metadataQuery enumerateResultsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            NSString* __unused displayName = [item valueForAttribute:NSMetadataItemDisplayNameKey];
            NSString* __unused path = [item valueForAttribute:NSMetadataItemPathKey];
            [mapps addObject:displayName];
            
            //NSLog(@">>> %@ - %@", displayName, path);
        }];
    }
    
    [self dispatchResult:[mapps copy] withContext:context forCallback:completeCb];
}

-(void)dispatchResult:(NSArray*)result withContext:(JSContextRef)context forCallback:(WebScriptObject*)callback {
    if (callback == nil)
        return;
    
    if ([callback isKindOfClass:[WebUndefined class]])
        return;
    
    JSObjectRef cbFn = [callback JSObject];
    JSValueProtect(context, cbFn);
    
    if (!JSObjectIsFunction(context, cbFn))
        return;
    
    JSValueRef jsArgs[] = { [self makeJsArray:result withContext:context] };
    JSValueRef __unused ret = JSObjectCallAsFunction(context, cbFn, NULL, 1, jsArgs, NULL);
    
    JSValueUnprotect(context, cbFn);
    
    cbFn = nil;
}

-(JSValueRef) makeJsArray:(NSArray*)array withContext:(JSContextRef)context{
    JSValueRef jsArray;
    
    NSUInteger i = 0;
    NSUInteger pcount = [array count];
    JSValueRef jsArgs[pcount];
    
    for (id v in array) {
        jsArgs[i++] = [self jsStringFromObject:v withContext:context];
    }
    jsArray = JSObjectMakeArray(context, pcount, jsArgs, NULL);
    
    return jsArray;
}

-(JSValueRef) jsStringFromObject:(id)object withContext:(JSContextRef)context{
    JSValueRef jsStr = nil;
    
    JSStringRef jstr = JSStringCreateWithUTF8CString([object UTF8String]);
    jsStr = JSValueMakeString(context, jstr);
    JSStringRelease(jstr);
    
    return jsStr;
}

-(void)queryDidStartGathering:(NSNotification *)notification {
    NSLog(@"Metadata Query: start gathering...");
}

-(void)queryDidUpdateGathering:(NSNotification *)notification {
    NSLog(@"Metadata Query: update gathering");
}

-(void)queryGatheringProgress:(NSNotification *)notification {
    NSLog(@"Metadata Query: gathering progress");
}

-(void)queryDidFinishGathering:(NSNotification *)notification {
    NSLog(@"Metadata Query: finish gathering.");
    
    dispatch_semaphore_signal(self.querySemaphore);
}

+(BOOL)isSelectorExcludedFromWebScript:(SEL)selector {
    return NO;
}

+(BOOL)isKeyExcludedFromWebScript:(const char*)name {
    return NO;
}

+(NSString*)webScriptNameForSelector:(SEL)selector {
    NSString* webScriptSelectorName = NSStringFromSelector(selector);
    
    if (selector == @selector(all:)) {
        return @"all";
    }
    
    return webScriptSelectorName;
}

+(NSString *)webScriptNameForKey:(const char *)name {
    NSString* webScriptKeyName = [NSString stringWithUTF8String:name];
    
    return webScriptKeyName;
}

@end
