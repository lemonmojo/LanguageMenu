//
//  AppDelegate.m
//  LanguageSwitcher
//
//  Created by Felix Deimel on 26.03.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import "AppDelegate.h"
#import "LMLanguage.h"

@implementation AppDelegate

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self updateStatusItem];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(defaultsChanged:)
     name:NSUserDefaultsDidChangeNotification
     object:nil];
}

- (void)defaultsChanged:(NSNotification*)aNotification
{
    [self updateStatusItem];
}

- (void)updateStatusItem
{
    NSArray* languages = [LMLanguage languages];
    
    LMLanguage* currentLanguage = [languages objectAtIndex:0];
    
    NSImage* icon = [currentLanguage icon];
    
    if (icon) {
        [statusItem setLength:NSSquareStatusItemLength];
        [statusItem setImage:icon];
        [statusItem setTitle:@""];
    } else {
        [statusItem setLength:NSVariableStatusItemLength];
        [statusItem setImage:nil];
        [statusItem setTitle:[currentLanguage languageName]];
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
        [item setImage:[language icon]];
        
        if ([language isActive])
            [item setState:NSOnState];
        
        [menu addItem:item];
    }
    
    [menu addItem:[NSMenuItem separatorItem]];
    
    item = [[NSMenuItem alloc] initWithTitle:@"Preferences..." action:@selector(statusMenuItemPreferences_Action:) keyEquivalent:@""];
    [menu addItem:item];
    
    item = [[NSMenuItem alloc] initWithTitle:@"About LanguageSwitcher" action:@selector(statusMenuItemAbout_Action:) keyEquivalent:@""];
    [menu addItem:item];
    
    [menu addItem:[NSMenuItem separatorItem]];
    
    item = [[NSMenuItem alloc] initWithTitle:@"Quit LanguageSwitcher" action:@selector(statusMenuItemQuit_Action:) keyEquivalent:@""];
    [menu addItem:item];
}

- (void)statusMenuItemLanguage_Action:(NSMenuItem*)sender {
    LMLanguage* language = [sender representedObject];
    
    [language makeActive];
}

- (void)statusMenuItemPreferences_Action:(NSMenuItem*)sender {
    
}

- (void)statusMenuItemAbout_Action:(NSMenuItem*)sender {
    [NSApp orderFrontStandardAboutPanel:self];
}

- (void)statusMenuItemQuit_Action:(NSMenuItem*)sender {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
