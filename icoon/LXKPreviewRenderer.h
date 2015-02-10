//
//  LXKPreviewRenderer.h
//  Icoon Screen Saver
//
//  Created by Oleg Kertanov on 2/6/2015.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LXKFrameRendererProtocol.h"

//
// TODO: consider to use QCView
// See http://stackoverflow.com/questions/8327138/cocoa-screensaver-embed-quartz
//
@interface LXKPreviewRenderer : NSObject<LXKFrameRendererProtocol> {
    @private
    
    NSView* _renderView;
}

@end
