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

//
// Private Methods
//
@interface LXKPreviewRenderer()
- (void)notifyChangedConfiguration;
@end

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
        
        _textLabel = [[NSTextField alloc] initWithFrame:rect];
        [_textLabel setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [_textLabel setBezeled:NO];
        [_textLabel setDrawsBackground:NO];
        [_textLabel setEditable:NO];
        [_textLabel setSelectable:NO];
        [_textLabel setAlignment:NSCenterTextAlignment];
        [_textLabel setTextColor:[NSColor darkGrayColor]];
        [_textLabel setStringValue:@""];
        [_renderView addSubview:_textLabel];
    }
    
    return self;
}

-(void)dealloc {
    if (_renderView != nil) {
        [_renderView removeFromSuperviewWithoutNeedingDisplay];
    }
    
    if (_textLabel != nil) {
        [_textLabel removeFromSuperviewWithoutNeedingDisplay];
    }
    
    _renderView = nil;
    
    _configDict = nil;
}

-(void)configureWithDict:(NSDictionary*)dict {
    _configDict = dict;
    [self notifyChangedConfiguration];
}

-(void)renderInRect:(NSRect)rect {
}

-(NSView*)renderView {
    return _renderView;
}

- (void)notifyChangedConfiguration {
    NSString* configUrl = _configDict != nil ? [_configDict valueForKey:@"Url"] : @"";
    
    if (configUrl != nil && [configUrl length] > 0) {
        NSString* configUrlWithPadding = [@"\n\n" stringByAppendingString:configUrl];
        [_textLabel setStringValue:configUrlWithPadding];
    }
}

@end
