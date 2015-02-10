//
//  LXKPreviewRenderer.m
//  Icoon Screen Saver
//
//  Created by Oleg Kertanov on 2/6/2015.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

#import "LXKPreviewRenderer.h"

@implementation LXKPreviewRenderer

-(instancetype)init {
    self = [super init];

    if (self) {
        NSRect rect = {{0, 0}, {300, 200}};
        _renderView = [[NSView alloc] initWithFrame:rect];
        [_renderView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [_renderView setAutoresizesSubviews:YES];
        [_renderView setWantsLayer:YES];
        _renderView.layer.backgroundColor = [[NSColor clearColor] CGColor];
        
        NSTextField* textLabel = [[NSTextField alloc] initWithFrame:rect];
        [textLabel setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [textLabel setStringValue:@"apple.com"];
        [textLabel setBezeled:NO];
        [textLabel setDrawsBackground:NO];
        [textLabel setEditable:NO];
        [textLabel setSelectable:NO];
        [textLabel setTextColor:[NSColor darkGrayColor]];
        [textLabel setAlignment:NSCenterTextAlignment];
        [_renderView addSubview:textLabel];
    }
    
    return self;
}

-(void)dealloc {
}

-(void)renderInRect:(NSRect)rect {
}

-(NSView*)renderView {
    return _renderView;
}

@end
