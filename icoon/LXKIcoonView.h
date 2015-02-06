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

typedef enum {
    RefreshDisabled,
    RefreshSeconds,
    RefreshMinutes
} RefreshUnits;

@interface LXKIcoonView : ScreenSaverView {
    @private
    WebView* _webView;
    NSWindow* _configSheet;
    NSTimer* _refreshTimer;
    
    ScreenSaverDefaults* _defaults;
    
    NSString* _refreshUrl;
    NSNumber* _refreshInterval;
    NSNumber* _refreshUnits;
}

@property (nonatomic, retain) IBOutlet WebView* webView;
@property (nonatomic, retain) IBOutlet NSTimer* refreshTimer;

@property (nonatomic, retain) IBOutlet NSWindow* configSheet;
@property (weak) IBOutlet NSTextField *urlField;
@property (weak) IBOutlet NSTextField *refreshIntervalField;
@property (weak) IBOutlet NSPopUpButtonCell *refreshUnitsPopUp;

@end
