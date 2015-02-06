//
//  LXKPreviewRenderer.m
//  icoon
//
//  Created by Oleg Kertanov on 2/6/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "LXKPreviewRenderer.h"

@implementation LXKPreviewRenderer

-(id)init {
    self = [super init];

    if (self) {
    }
    
    return self;
}

- (void)dealloc {
}

- (void)renderInRect:(NSRect)rect {
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBFillColor(context, 0.9, 0.9, 0.9, 1.0);
    CGContextFillRect(context, NSRectToCGRect(rect));
}

@end
