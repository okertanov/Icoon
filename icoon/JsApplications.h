//
//  JsApplications.h
//  icoon
//
//  Created by Oleg Kertanov on 3/19/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsObject.h"

//
// JsApplications - "/Applications" bridge
//
@interface JsApplications : JsObject {
    @public
    NSString* module;
}

@property (strong, nonatomic) NSString* module;

-(void)all:(WebScriptObject*)completeCb;

@end
