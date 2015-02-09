//
//  LXKRenderer.h
//  Icoon Screen Saver
//
//  Created by Oleg Kertanov on 2/6/2015.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#ifndef icoon_LXKRenderer_h
#define icoon_LXKRenderer_h

@protocol LXKRendererProtocol <NSObject>
-(instancetype)init;
- (void)dealloc;
- (void)renderInRect:(NSRect)rect;
@end

#endif
