//
//  NSImage+ImageUtils.m
//  LanguageMenu
//
//  Created by Felix Deimel on 28.03.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import "NSImage+ImageUtils.h"

@implementation NSImage (ImageUtils)

- (NSImage *)resizedImageForSize:(NSSize)size
{
    NSImage *resizedImage = [[[NSImage alloc] initWithSize:size] autorelease];
    
    [resizedImage lockFocus];
    [self drawInRect:NSMakeRect(0, 0, size.width, size.height) fromRect:NSMakeRect(0, 0, self.size.width, self.size.height) operation:NSCompositeSourceOver fraction:1.0];
    [resizedImage unlockFocus];
    
    return resizedImage;
}

@end
