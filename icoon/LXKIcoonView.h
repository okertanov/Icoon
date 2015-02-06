//
//  icoonView.h
//  icoon
//
//  Created by Oleg Kertanov on 2/6/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <ScreenSaver/ScreenSaver.h>

#import "LXKRenderer.h"

typedef enum {
    RefreshDisabled = 0,
    RefreshSeconds = 1,
    RefreshMinutes = 2
} RefreshUnits;

@interface LXKIcoonView : ScreenSaverView {
    @private
    
    //
    // Synthesized Propertiew
    //
    WebView* _webView;
    NSTimer* _refreshTimer;
    
    //
    // POD Fields
    //
    ScreenSaverDefaults* _defaults;
    NSString* _refreshUrl;
    NSNumber* _refreshInterval;
    NSNumber* _refreshUnits;
    
    //
    // Internals
    //
    id<LXKRenderer> _renderer;
}

@property (nonatomic, retain) IBOutlet WebView* webView;
@property (nonatomic, retain) IBOutlet NSTimer* refreshTimer;

//
// IBOutlets
//
@property (weak) IBOutlet NSWindow* configSheet;
@property (weak) IBOutlet NSTextField *urlField;
@property (weak) IBOutlet NSTextField *refreshIntervalField;
@property (weak) IBOutlet NSPopUpButtonCell *refreshUnitsPopUp;

@end
