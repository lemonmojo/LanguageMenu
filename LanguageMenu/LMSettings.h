//
//  LMSettings.h
//  LanguageMenu
//
//  Created by Felix Deimel on 05.04.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const PREFKEY_SHOWCOUNTRYFLAG = @"ShowCountryFlag";
static NSString* const PREFKEY_SHOWLANGUAGENAME = @"ShowLanguageName";

@interface LMSettings : NSObject

+ (NSUserDefaults*)defaults;
+ (void)addDefaultsObserver:(id)observer selector:(SEL)selector;
+ (void)removeDefaultsObserver:(id)observer;

+ (BOOL)showCountryFlag;
+ (void)setShowCountryFlag:(BOOL)value;
+ (void)toggleShowCountryFlag;

+ (BOOL)showLanguageName;
+ (void)setShowLanguageName:(BOOL)value;
+ (void)toggleShowLanguageName;

@end
