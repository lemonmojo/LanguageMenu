//
//  AppDelegate.m
//  LanguageSwitcher
//
//  Created by Felix Deimel on 26.03.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import "AppDelegate.h"
#import "LMLanguage.h"
#import "LMSettings.h"
#import "NSImage+ImageUtils.h"

@implementation AppDelegate

- (void)dealloc
{
    [LMSettings removeDefaultsObserver:self];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [LMSettings addDefaultsObserver:self selector:@selector(defaultsChanged:)];
    
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self updateStatusItem];
}

- (void)defaultsChanged:(NSNotification*)aNotification
{
    [self updateStatusItem];
}

- (void)updateStatusItem
{
    NSArray* languages = [LMLanguage languages];
    
    LMLanguage* currentLanguage = [languages objectAtIndex:0];
    
    NSImage* icon = nil;
    
    if ([LMSettings showCountryFlag] &&
        [currentLanguage icon]) {
        icon = [[[currentLanguage icon] copy] autorelease];
        [icon setSize:NSMakeSize(16, 16)];
    }
    
    if ([LMSettings showCountryFlag] &&
        icon) {
        [statusItem setLength:NSSquareStatusItemLength];
        [statusItem setImage:icon];
        [statusItem setTitle:@""];
    }
    
    if (!icon || [LMSettings showLanguageName]) {
        [statusItem setLength:NSVariableStatusItemLength];
        [statusItem setTitle:[currentLanguage languageName]];
        
        if (!icon) {
            [statusItem setImage:nil];
        }
    }
}

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    if (menu != statusMenu)
        return;
    
    [menu removeAllItems];
    
    NSArray* languages = [LMLanguage languages];
    
    NSMenuItem* item = nil;
    
    for (LMLanguage* language in languages) {
        item = [[NSMenuItem alloc] initWithTitle:language.languageName action:@selector(statusMenuItemLanguage_Action:) keyEquivalent:@""];
        [item setRepresentedObject:language];
        
        NSImage* icon = nil;
        
        if ([language icon]) {
            icon = [[[language icon] copy] autorelease];
            [icon setSize:NSMakeSize(16, 16)];
        }
        
        if (icon) {
            [item setImage:icon];
        }
        
        if ([language isActive]) {
            [item setState:NSOnState];
        }
        
        [menu addItem:item];
        [item release];
    }
    
    [menu addItem:[NSMenuItem separatorItem]];
    
    NSMenu* prefsMenu = [[NSMenu alloc] initWithTitle:@"Preferences"];
    
    item = [[NSMenuItem alloc] initWithTitle:@"Show Country Flag" action:@selector(statusMenuItemPreferencesShowCountryFlag_Action:) keyEquivalent:@""];
    [item setState:[LMSettings showCountryFlag]];
    [prefsMenu addItem:item];
    [item release];
    
    item = [[NSMenuItem alloc] initWithTitle:@"Show Language Name" action:@selector(statusMenuItemPreferencesShowName_Action:) keyEquivalent:@""];
    [item setState:[LMSettings showLanguageName]];
    [prefsMenu addItem:item];
    [item release];
    
    [prefsMenu addItem:[NSMenuItem separatorItem]];
    
    item = [[NSMenuItem alloc] initWithTitle:@"Start LanguageMenu at Login" action:@selector(statusMenuItemPreferencesStartAtLogin_Action:) keyEquivalent:@""];
    [item setState:[LMSettings startAtLogin]];
    [prefsMenu addItem:item];
    [item release];
    
    item = [[NSMenuItem alloc] initWithTitle:@"System Preferences" action:@selector(statusMenuItemPreferencesSystemPreferences_Action:) keyEquivalent:@""];
    [prefsMenu addItem:item];
    [item release];
    
    item = [[NSMenuItem alloc] initWithTitle:@"Preferences" action:nil keyEquivalent:@""];
    [item setSubmenu:prefsMenu];
    [prefsMenu release];
    
    [menu addItem:item];
    [item release];
    
    item = [[NSMenuItem alloc] initWithTitle:@"About LanguageMenu" action:@selector(statusMenuItemAbout_Action:) keyEquivalent:@""];
    [menu addItem:item];
    [item release];
    
    [menu addItem:[NSMenuItem separatorItem]];
    
    item = [[NSMenuItem alloc] initWithTitle:@"Quit LanguageMenu" action:@selector(statusMenuItemQuit_Action:) keyEquivalent:@""];
    [menu addItem:item];
    [item release];
}

- (void)statusMenuItemLanguage_Action:(NSMenuItem*)sender
{
    LMLanguage* language = [sender representedObject];
    
    [language makeActive];
}

- (void)statusMenuItemAbout_Action:(NSMenuItem*)sender
{
    [NSApp orderFrontStandardAboutPanel:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)statusMenuItemQuit_Action:(NSMenuItem*)sender
{
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

- (void)statusMenuItemPreferencesShowCountryFlag_Action:(NSMenuItem*)sender
{
    [LMSettings toggleShowCountryFlag];
}

- (void)statusMenuItemPreferencesShowName_Action:(NSMenuItem*)sender
{
    [LMSettings toggleShowLanguageName];
}

- (void)statusMenuItemPreferencesStartAtLogin_Action:(NSMenuItem*)sender
{
    [LMSettings toggleStartAtLogin];
}

- (void)statusMenuItemPreferencesSystemPreferences_Action:(NSMenuItem*)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL fileURLWithPath:@"/System/Library/PreferencePanes/Localization.prefPane"]];
}

@end
