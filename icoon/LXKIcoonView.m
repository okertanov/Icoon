//
//  LXKIcoonView.m
//  Icoon Screen Saver
//
//  Created by Oleg Kertanov on 2/6/2015.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#import "LXKIcoonView.h"
#import "LXKPreviewRenderer.h"

//
// Private Constants
//
static NSString* const ScreenSaverName = @"me.lexiko.icoon";
static NSString* const BlankUrl = @"about:blank";
static NSString* const DefaultsURLKey = @"URL";
static NSString* const DefaultsURL = @"http://tweetping.net/";
static NSString* const DefaultsRefreshIntervalKey = @"RefreshInterval";
static double const DefaultsRefreshInterval = 1.0;
static NSString* const DefaultsRefreshUnitsKey = @"RefreshUnits";
static unsigned long const DefaultsRefreshUnits = (unsigned long)RefreshDisabled;

//
// Private Methods
//
@interface LXKIcoonView()
- (IBAction) okClick:(id)sender;
- (IBAction)popUpClick:(id)sender;

- (void) updateRefreshIntervalAvailable;

- (ScreenSaverDefaults*) initializeDefaults;
- (void)loadDefaults;
- (void)saveDefaults;
- (void)notifyChangedDefaults;
@end

//
// Implementation
//
@implementation LXKIcoonView

@synthesize webView = _webView;
@synthesize refreshTimer = _refreshTimer;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) {
        [self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [self setAutoresizesSubviews:YES];
        
        _defaults = [self initializeDefaults];
        [self loadDefaults];
        
        if (self.isPreview) {
            _renderer = [[LXKPreviewRenderer alloc] init];
            [_renderer configureWithDict:@{ @"Url" : _refreshUrl }];
            NSView* rendererView = [_renderer renderView];
            [rendererView setFrame:self.bounds];
            [self addSubview:rendererView];
        }
        else {
            _webView = [[LXKWebView alloc] initWithFrame:self.bounds];
            [self addSubview:_webView];
        }
    }
    
    return self;
}

- (void)startAnimation {
    [super startAnimation];
    
    if (_webView != nil) {
        [_webView load:_refreshUrl];
    }
}

- (void)stopAnimation {
    if (_webView != nil) {
        [_webView load:BlankUrl];
    }
    
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
}

- (void)animateOneFrame {
}

- (BOOL)isAnimating {
    BOOL animating = [super isAnimating];
    
    return animating;
}

- (BOOL)isPreview {
    BOOL preview = [super isPreview];
    
    return preview;
}

+ (BOOL)performGammaFade {
    return YES;
}

- (BOOL)hasConfigureSheet {
    return YES;
}

- (NSWindow*)configureSheet {
    if (self.configSheet == nil) {
        #pragma GCC diagnostic push
        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        if (![NSBundle loadNibNamed:@"ConfigureSheet" owner:self]) {
            NSLog(@"Unable to load configuration sheet");
        }
        #pragma GCC diagnostic pop
    }
    
    [self.urlField setStringValue:_refreshUrl];
    [self.refreshIntervalField setDoubleValue:[_refreshInterval doubleValue]];
    [self.refreshUnitsPopUp selectItemWithTag:[_refreshUnits longValue]];
    
    [self updateRefreshIntervalAvailable];
    
    return self.configSheet;
}

- (void)dealloc {
    _webView = nil;
    _renderer = nil;
    _defaults = nil;
}

- (IBAction) okClick:(id)sender {
    [self saveDefaults];
    [self notifyChangedDefaults];
    [[NSApplication sharedApplication] endSheet:self.configSheet];
}

- (IBAction)popUpClick:(id)sender {
    [self updateRefreshIntervalAvailable];
}

- (void)keyDown:(NSEvent *)theEvent {
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
}

- (BOOL)acceptsFirstResponder {
    return NO;
}

- (BOOL)resignFirstResponder {
    return YES;
}

- (void) updateRefreshIntervalAvailable {
    [self.refreshIntervalField
     setEnabled:[[self.refreshUnitsPopUp selectedItem] tag] > RefreshDisabled];
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
    [_webView load:_refreshUrl];
    
    // Refresh renderer
    if (_renderer != nil) {
        [_renderer configureWithDict:@{ @"Url" : _refreshUrl }];
    }
}

@end
