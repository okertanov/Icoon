//
//  LXKPreviewRenderer.m
//  Icoon Screen Saver
//
//  Created by Oleg Kertanov on 2/6/2015.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "LXKPreviewRenderer.h"

@implementation LXKPreviewRenderer

-(instancetype)init {
    self = [super init];

    if (self) {
    }
    
    return self;
}

- (void)dealloc {
}

- (void)renderInRect:(NSRect)rect {
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextFillRect(context, NSRectToCGRect(rect));
}

@end
