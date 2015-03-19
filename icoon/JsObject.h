//
//  JsObject.h
//  icoon
//
//  Created by Oleg Kertanov on 3/19/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXKJsScriptingBridgeProtocol.h"

@interface JsObject : NSObject

@property (weak, nonatomic) id<LXKJsScriptingBridgeProtocol> scriptingBridge;

-(instancetype) __unavailable init; 
-(instancetype)initWithScriptingBridge:(id<LXKJsScriptingBridgeProtocol>)bridge;
-(void)dealloc;

@end
