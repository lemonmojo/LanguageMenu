//
//  LMLanguage.m
//  LanguageSwitcher
//
//  Created by Felix Deimel on 26.03.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import "LMLanguage.h"
#import <Carbon/Carbon.h>

@implementation LMLanguage

@synthesize languageIdentifier, canonicalLanguageIdentifier;

+ (LMLanguage*)languageWithNonCanonicalLanguageIdentifier:(NSString*)languageIdentifier
{
    LMLanguage* language = [[[LMLanguage alloc] init] autorelease];
    
    language.languageIdentifier = languageIdentifier;
    language.canonicalLanguageIdentifier = [(NSString*)CFLocaleCreateCanonicalLanguageIdentifierFromString(NULL, (CFStringRef)languageIdentifier) autorelease];
    
    return language;
}

+ (LMLanguage*)languageWithCanonicalLanguageIdentifier:(NSString*)canonicalLanguageIdentifier
{
    LMLanguage* language = [[[LMLanguage alloc] init] autorelease];
    
    language.languageIdentifier = canonicalLanguageIdentifier;
    language.canonicalLanguageIdentifier = canonicalLanguageIdentifier;
    
    return language;
}

+ (NSArray*)languages
{
    NSArray* appleLanguages = [LMLanguage getAppleLanguages];
    
    NSMutableArray* languages = [NSMutableArray array];
    
    for (NSString* langId in appleLanguages) {
        LMLanguage* lang = [LMLanguage languageWithNonCanonicalLanguageIdentifier:langId];
        
        [languages addObject:lang];
    }
    
    return [languages copy];
}

+ (NSArray*)getAppleLanguages
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* globalDomain = [defaults persistentDomainForName:@"NSGlobalDomain"];
    NSArray* appleLanguages = [globalDomain objectForKey:@"AppleLanguages"];
    
    NSLog(@"%@", appleLanguages.description);
    
    return appleLanguages;
}

+ (void)setAppleLanguages:(NSArray*)appleLanguages
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *globalDomain = [[defaults persistentDomainForName:@"NSGlobalDomain"] mutableCopy];
    
    [globalDomain setValue:appleLanguages forKey:@"AppleLanguages"];
    [defaults setPersistentDomain:globalDomain forName:@"NSGlobalDomain"];
    [defaults synchronize];
}

+ (void)setActiveLanguage:(NSString*)identifier
{
    NSMutableArray* appleLanguages = [[LMLanguage getAppleLanguages] mutableCopy];
    
    [appleLanguages removeObjectIdenticalTo:identifier];
    
    [appleLanguages insertObject:identifier atIndex:0];
    
    [LMLanguage setAppleLanguages:[appleLanguages copy]];
}

+ (NSDictionary*)languageInputSourceMappings
{
    if (!s_languageInputSourceMappings) {
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"language_mappings" ofType:@"txt"];
        NSString* str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        NSArray* lines = [str componentsSeparatedByString:@"\n"];
        
        NSMutableDictionary* mappings = [NSMutableDictionary dictionary];
        
        for (NSString* line in lines) {
            if ([line hasPrefix:@"//"])
                continue;
            
            NSArray* pair = [line componentsSeparatedByString:@"="];
            
            NSString* langId = [pair objectAtIndex:0];
            NSString* inSrcId = [pair objectAtIndex:1];
            
            [mappings setValue:inSrcId forKey:langId];
        }
        
        s_languageInputSourceMappings = [mappings copy];
    }
    
    return s_languageInputSourceMappings;
}

- (NSString*)localeIdentifier
{
    return [NSLocale canonicalLocaleIdentifierFromString:canonicalLanguageIdentifier];
}

- (NSLocale*)locale
{
    return [[NSLocale alloc] initWithLocaleIdentifier:[self localeIdentifier]];
}

- (NSString*)languageName
{
    return [[self locale] displayNameForKey:NSLocaleIdentifier value:canonicalLanguageIdentifier];
}

- (NSString*)countryCode
{
    return [[self locale] objectForKey:NSLocaleCountryCode];
}

- (NSString*)countryName
{
    return [[self locale] displayNameForKey:NSLocaleCountryCode value:canonicalLanguageIdentifier];
}

- (BOOL)isActive
{
    NSArray* appleLanguages = [LMLanguage getAppleLanguages];
    
    return ([[appleLanguages objectAtIndex:0] isEqualToString:languageIdentifier]);
}

- (void)makeActive
{
    [LMLanguage setActiveLanguage:languageIdentifier];
}

- (NSImage*)icon
{
    NSDictionary* mappings = [LMLanguage languageInputSourceMappings];
    
    NSImage* img = nil;
    
    NSString* inSrcId = [mappings valueForKey:self.canonicalLanguageIdentifier];
    
    if (inSrcId &&
        ![inSrcId isEqualToString:@""]) {
        CFArrayRef inputs = TISCreateInputSourceList(NULL, true);
        NSUInteger count = CFArrayGetCount(inputs);
        
        for (NSUInteger i = 0; i < count; i++) {
            TISInputSourceRef inputSource = (TISInputSourceRef)CFArrayGetValueAtIndex(inputs, i);
            NSString* inputSourceID = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID);
            
            if ([inputSourceID isEqualToString:inSrcId]) {
                IconRef icon = TISGetInputSourceProperty(inputSource, kTISPropertyIconRef);
                img = [[NSImage alloc] initWithIconRef:icon];
                break;
            }
        }
        
        CFRelease(inputs);
    }
    
    if (!img)
        img = [NSImage imageNamed:inSrcId];
    
    return img;
    
    /* CFArrayRef inputs = TISCreateInputSourceList(NULL, true);
     NSUInteger count = CFArrayGetCount(inputs);
     
     for (NSUInteger i = 0; i < count; i++) {
     TISInputSourceRef inputSource = (TISInputSourceRef)CFArrayGetValueAtIndex(inputs, i);
     NSString* inputSourceID = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID);
     
     CFStringRef type = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceCategory);
     
     if (!CFStringCompare(type, kTISCategoryKeyboardInputSource, 0)) {
     NSArray* langs = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceLanguages);
     
     NSString* name = TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName);
     NSString* currLangName = [self languageName];
     
     if ([[langs objectAtIndex:0] isEqualToString:canonicalLanguageIdentifier]) {
     IconRef icon = TISGetInputSourceProperty(inputSource, kTISPropertyIconRef);
     img = [[NSImage alloc] initWithIconRef:icon];
     break;
     }
     }
     }
     
     CFRelease(inputs);
     
     return img; */
}

@end
