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

@end
