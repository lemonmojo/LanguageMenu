//
//  LMLanguage.h
//  LanguageSwitcher
//
//  Created by Felix Deimel on 26.03.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMLanguage : NSObject {
    NSString* languageIdentifier;
    NSString* canonicalLanguageIdentifier;
}

@property (nonatomic, retain) NSString* languageIdentifier;
@property (nonatomic, retain) NSString* canonicalLanguageIdentifier;

+ (LMLanguage*)languageWithNonCanonicalLanguageIdentifier:(NSString*)languageIdentifier;
+ (LMLanguage*)languageWithCanonicalLanguageIdentifier:(NSString*)canonicalLanguageIdentifier;
+ (NSArray*)languages;
+ (NSArray*)getAppleLanguages;
+ (void)setAppleLanguages:(NSArray*)appleLanguages;
+ (void)setActiveLanguage:(NSString*)identifier;
+ (NSDictionary*)languageInputSourceMappings;

- (NSString*)localeIdentifier;
- (NSLocale*)locale;
- (NSString*)languageName;
- (NSString*)countryCode;
- (NSString*)countryName;
- (NSImage*)icon;

- (BOOL)isActive;
- (void)makeActive;

@end
