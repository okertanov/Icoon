//
//  icoonView.m
//  icoon
//
//  Created by Oleg Kertanov on 2/6/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import "LXKIcoonView.h"

@implementation LXKIcoonView

@synthesize webView =_webView;
@synthesize configSheet = _configSheet;
@synthesize refreshTimer = _refreshTimer;

static NSString* const ScreenSaverName = @"me.lexiko.icoon";
static NSString* const DefaultsURLKey = @"URL";
static NSString* const DefaultsURL = @"https://www.google.com/";
static NSString* const DefaultsRefreshIntervalKey = @"RefreshInterval";
static const double DefaultsRefreshInterval = 1.0;
static NSString* const DefaultsRefreshUnitsKey = @"RefreshUnits";
static const unsigned long DefaultsRefreshUnits = (unsigned long)RefreshDisabled;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) {
        [self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [self setAutoresizesSubviews:YES];
        
        _defaults = [self initializeDefaults];
        [self loadDefaults];
        
        _webView = [self initializeWebView];
        
        //[self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation {
    [super startAnimation];
    
    [self loadWebView];
}

- (void)stopAnimation {
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
}

- (void)animateOneFrame {
    return;
}

+ (BOOL)performGammaFade {
    return YES;
}

- (BOOL)hasConfigureSheet {
    return YES;
}

- (NSWindow*)configureSheet {
    if (self.configSheet == nil) {
        if (![NSBundle loadNibNamed:@"ConfigureSheet" owner:self]) {
            NSLog(@"Unable to load configuration sheet");
        }
    }
    
    [self.urlField setStringValue:_refreshUrl];
    [self.refreshIntervalField setDoubleValue:[_refreshInterval doubleValue]];
    [self.refreshUnitsPopUp selectItemWithTag:[_refreshUnits longValue]];
    
    [self updateRefreshIntervalAvailable];
    
    return self.configSheet;
}

- (void)dealloc {
    [self.webView setFrameLoadDelegate:nil];
    [self.webView setPolicyDelegate:nil];
    [self.webView setUIDelegate:nil];
    [self.webView setEditingDelegate:nil];
    [self.webView close];
}

- (IBAction) okClick:(id)sender {
    [self saveDefaults];
    [self notifyChangedDefaults];
    [[NSApplication sharedApplication] endSheet:self.configSheet];
}

- (IBAction)popUpClick:(id)sender {
    [self updateRefreshIntervalAvailable];
}

- (void) updateRefreshIntervalAvailable {
    [self.refreshIntervalField setEnabled:[[self.refreshUnitsPopUp selectedItem] tag] > 0];
}

- (ScreenSaverDefaults*) initializeDefaults {
    ScreenSaverDefaults* defaults = [ScreenSaverDefaults defaultsForModuleWithName:ScreenSaverName];
    
    [defaults registerDefaults:
     [NSDictionary dictionaryWithObjectsAndKeys:
        DefaultsURL, DefaultsURLKey,
        [NSNumber numberWithDouble:DefaultsRefreshInterval], DefaultsRefreshIntervalKey,
        [NSNumber numberWithLong:DefaultsRefreshUnits], DefaultsRefreshUnitsKey,
        nil]
     ];
    
    return defaults;
}

- (void)loadDefaults {
    _refreshUrl = [_defaults valueForKey: DefaultsURLKey];
    _refreshInterval =[_defaults valueForKey: DefaultsRefreshIntervalKey];
    _refreshUnits = [_defaults valueForKey: DefaultsRefreshUnitsKey];
}

- (void)saveDefaults {
    [_defaults setValue:[self.urlField stringValue] forKey:DefaultsURLKey];
    [_defaults setValue:[NSNumber numberWithDouble:[self.refreshIntervalField doubleValue]] forKey:DefaultsRefreshIntervalKey];
    [_defaults setValue:[NSNumber numberWithLong:[[self.refreshUnitsPopUp selectedItem] tag]] forKey:DefaultsRefreshUnitsKey];
    [_defaults synchronize];
}

- (void)notifyChangedDefaults {
    [self loadDefaults];
    [self loadWebView];
}

- (WebView*)initializeWebView {
    WebView* webView = [[WebView alloc] initWithFrame:[self bounds] frameName:nil groupName:nil];
    
    [webView setFrameLoadDelegate:self];
    [webView setPolicyDelegate:self];
    [webView setUIDelegate:self];
    [webView setEditingDelegate:self];
    [webView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [webView setAutoresizesSubviews:YES];
    [webView setDrawsBackground:NO];
    [webView setShouldUpdateWhileOffscreen:YES];
    
    NSColor *color = [NSColor colorWithCalibratedWhite:0.0 alpha:1.0];
    [[webView layer] setBackgroundColor:color.CGColor];
    
    [self addSubview:webView];
    
    return webView;
}

- (void)loadWebView {
    [self.webView setMainFrameURL:_refreshUrl];
}

- (void)refreshWebView {
    [self.webView reload:nil];
}

#pragma mark Web View Delegates

#pragma mark WebPolicyDelegate

- (void)webView:(WebView *)webView
    decidePolicyForNewWindowAction:(NSDictionary *)actionInformation
    request:(NSURLRequest *)request
    newFrameName:(NSString *)frameName
    decisionListener:(id < WebPolicyDecisionListener >)listener {
    // Don't open new windows.
    [listener ignore];
}

- (void)webView:(WebView *)webView didFinishLoadForFrame:(WebFrame *)frame {
    [self.webView resignFirstResponder];
    [[[self.webView mainFrame] frameView] setAllowsScrolling:NO];
}

- (NSResponder *)webViewFirstResponder:(WebView *)sender {
    return self;
}

- (void)webViewClose:(WebView *)sender {
    return;
}

- (BOOL)webViewIsResizable:(WebView *)sender {
    return NO;
}

- (BOOL)webViewAreToolbarsVisible:(WebView *)sender {
    return NO;
}

- (BOOL)webViewIsStatusBarVisible:(WebView *)sender {
    return NO;
}

- (void)webViewRunModal:(WebView *)sender {
    return;
}

- (void)webViewShow:(WebView *)sender {
    return;
}

- (void)webViewUnfocus:(WebView *)sender {
    return;
}

- (NSView *)hitTest:(NSPoint)aPoint {
    return self;
}

- (void)keyDown:(NSEvent *)theEvent {
    return;
}

- (void)keyUp:(NSEvent *)theEvent {
    return;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)resignFirstResponder {
    return NO;
}

@end
