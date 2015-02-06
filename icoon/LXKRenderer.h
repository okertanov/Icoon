//
//  LXKRenderer.h
//  icoon
//
//  Created by Oleg Kertanov on 2/6/15.
//  Copyright (c) 2015 Oleg Kertanov. All rights reserved.
//

#ifndef icoon_LXKRenderer_h
#define icoon_LXKRenderer_h

@protocol LXKRenderer <NSObject>
-(id)init;
- (void)dealloc;
- (void)renderInRect:(NSRect)rect;
@end

#endif
