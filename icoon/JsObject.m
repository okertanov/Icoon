//
//  JsObject.m
//  icoon
//
//  Created by Oleg Kertanov on 3/19/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import "JsObject.h"

@implementation JsObject

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

@end
