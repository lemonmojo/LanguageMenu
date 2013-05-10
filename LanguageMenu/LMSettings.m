//
//  LMSettings.m
//  LanguageMenu
//
//  Created by Felix Deimel on 05.04.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import "LMSettings.h"

@implementation LMSettings

+ (NSUserDefaults*)defaults
{
    return [NSUserDefaults standardUserDefaults];
}

+ (void)addDefaultsObserver:(id)observer selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter]
     addObserver:observer
     selector:selector
     name:NSUserDefaultsDidChangeNotification
     object:nil];
}

+ (void)removeDefaultsObserver:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:NSUserDefaultsDidChangeNotification object:nil];
}

+ (BOOL)showCountryFlag
{
    return [[LMSettings defaults] boolForKey:PREFKEY_SHOWCOUNTRYFLAG];
}

+ (void)setShowCountryFlag:(BOOL)value
{
    [[LMSettings defaults] setBool:value forKey:PREFKEY_SHOWCOUNTRYFLAG];
}

+ (void)toggleShowCountryFlag
{
    [LMSettings setShowCountryFlag:![LMSettings showCountryFlag]];
}

+ (BOOL)showLanguageName
{
    return [[LMSettings defaults] boolForKey:PREFKEY_SHOWLANGUAGENAME];
}

+ (void)setShowLanguageName:(BOOL)value
{
    [[LMSettings defaults] setBool:value forKey:PREFKEY_SHOWLANGUAGENAME];
}

+ (void)toggleShowLanguageName
{
    [LMSettings setShowLanguageName:![LMSettings showLanguageName]];
}

+ (BOOL)startAtLogin
{
    NSString* appPath = [[NSBundle mainBundle] bundlePath];
	CFURLRef appUrl = (CFURLRef)[NSURL fileURLWithPath:appPath];
	
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
	if (loginItems) {
		UInt32 seedValue;
		NSArray* loginItemsArray = (NSArray*)LSSharedFileListCopySnapshot(loginItems, &seedValue);
        
		for(int i = 0; i < [loginItemsArray count]; i++){
			LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)[loginItemsArray objectAtIndex:i];
            
			if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &appUrl, NULL) == noErr) {
				NSString * urlPath = [(NSURL*)appUrl path];
                
				if ([urlPath compare:appPath] == NSOrderedSame)
                    return YES;
			}
		}
        
		[loginItemsArray release];
	}
    
    CFRelease(loginItems);
    
    return NO;
}

+ (void)setStartAtLogin:(BOOL)value
{
    NSString* appPath = [[NSBundle mainBundle] bundlePath];
	CFURLRef appUrl = (CFURLRef)[NSURL fileURLWithPath:appPath];
	
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
	if (loginItems) {
        if (value) {
            LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, appUrl, NULL, NULL);
            
            if (item)
                CFRelease(item);
        } else {
            UInt32 seedValue;
            NSArray* loginItemsArray = (NSArray*)LSSharedFileListCopySnapshot(loginItems, &seedValue);
            
            for(int i = 0; i < [loginItemsArray count]; i++){
                LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)[loginItemsArray objectAtIndex:i];
                
                if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &appUrl, NULL) == noErr) {
                    NSString * urlPath = [(NSURL*)appUrl path];
                    
                    if ([urlPath compare:appPath] == NSOrderedSame)
                        LSSharedFileListItemRemove(loginItems,itemRef);
                }
            }
            
            [loginItemsArray release];
        }
    }
    
    CFRelease(loginItems);
}

+ (void)toggleStartAtLogin
{
    [LMSettings setStartAtLogin:![LMSettings startAtLogin]];
}

@end
