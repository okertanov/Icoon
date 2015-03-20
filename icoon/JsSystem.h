//
//  JsSystem.h
//  icoon
//
//  Created by Oleg Kertanov on 3/20/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsModule.h"

//
// JsSystem - system module: Icoon.system
//
@interface JsSystem : JsModule {
    @public
    NSString* os;
    NSString* home;
    NSString* logo;
    NSString* uptime;
    NSString* hostname;
    NSString* username;
    NSString* machine;
    NSString* kernel;
    NSString* locale;
}

@property (strong, nonatomic) NSString* os;
@property (strong, nonatomic) NSString* home;
@property (strong, nonatomic) NSString* logo;
@property (strong, nonatomic) NSString* uptime;
@property (strong, nonatomic) NSString* hostname;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* machine;
@property (strong, nonatomic) NSString* kernel;
@property (strong, nonatomic) NSString* locale;

-(void)execute:(NSString*)executable
            withArguments:(WebScriptObject*)arguments
            complete:(WebScriptObject*)completeCb;

@end
