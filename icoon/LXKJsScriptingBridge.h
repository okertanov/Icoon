//
//  LXKJsScriptingBridge.h
//  icoon
//
//  Created by Oleg Kertanov on 3/19/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXKJsScriptingBridgeProtocol.h"

@class JsSystem;
@class JsApplications;

@interface LXKJsScriptingBridge : NSObject<LXKJsScriptingBridgeProtocol> {
    @public
    NSString* module;
    
    @protected
    JSContextRef jsContext;
}

//
// Module public JS objects
//
@property (strong, nonatomic) NSString* module;
@property (strong, nonatomic) JsSystem* system;
@property (strong, nonatomic) JsApplications* applications;

-(instancetype)initWithContext:(JSContextRef)context;
-(void)dealloc;

-(JSContextRef)getJsContext;

@end
