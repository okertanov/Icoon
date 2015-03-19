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

-(NSArray*)all {
    NSArray* apps = [[NSArray alloc] init];
    
    [self startQueryApplications];
    
    return apps;
}

-(void)startQueryApplications {
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
        
        [self stopQueryApplications];
    });
}

-(void)stopQueryApplications {
    [self.metadataQuery disableUpdates];
    [self.metadataQuery stopQuery];
    
    NSUInteger resultCount = [self.metadataQuery resultCount];
    if (resultCount > 0) {
        NSLog(@">>> Found apps: %u", (unsigned int)resultCount);
        
        NSMutableArray* mapps = [[NSMutableArray alloc] init];
        
        [self.metadataQuery enumerateResultsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            NSString* __unused displayName = [item valueForAttribute:NSMetadataItemDisplayNameKey];
            NSString* __unused path = [item valueForAttribute:NSMetadataItemPathKey];
            [mapps addObject:displayName];
            
            //NSLog(@">>> %@ - %@", displayName, path);
        }];
        
        // apps = [mapps copy];
    }
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
    
    return webScriptSelectorName;
}

+(NSString *)webScriptNameForKey:(const char *)name {
    NSString* webScriptKeyName = [NSString stringWithUTF8String:name];
    
    return webScriptKeyName;
}

@end
