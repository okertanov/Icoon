//
//  LXKFrameRendererProtocol.h
//  Icoon Screen Saver
//
//  Created by Oleg Kertanov on 2/6/2015.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <AppKit/AppKit.h>

@protocol LXKFrameRendererProtocol <NSObject>
-(instancetype)init;
-(void)dealloc;

-(void)configureWithDict:(NSDictionary*)dict;
-(void)renderInRect:(NSRect)rect;
-(NSView*)renderView;
@end

