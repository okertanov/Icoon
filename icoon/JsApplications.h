//
//  JsApplications.h
//  icoon
//
//  Created by Oleg Kertanov on 3/19/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsModule.h"

//
// JsApplications - "/Applications" bridge: Icoon.applications
//
@interface JsApplications : JsModule

-(void)all:(WebScriptObject*)completeCb;

-(void)iconPathFor:(NSString*)appId
          complete:(WebScriptObject*)completeCb;

@end
