//
//  NSImage+ImageUtils.h
//  LanguageMenu
//
//  Created by Felix Deimel on 28.03.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (ImageUtils)

- (NSImage *)resizedImageForSize:(NSSize)size;

@end
