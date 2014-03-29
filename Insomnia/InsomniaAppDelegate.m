#import "InsomniaAppDelegate.h"

@implementation InsomniaAppDelegate

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.powerManagementAssertionId = 0;
    
    self.statusMenu = [[NSMenu alloc] initWithTitle:@"Insomnia"];
    [self.statusMenu setDelegate:self];
    
    self.switchMenuItem = [[NSMenuItem alloc] initWithTitle:@"Enable Insomnia" action:@selector(enableInsomnia) keyEquivalent:@""];
    [self.switchMenuItem setTarget:self];
    [self.statusMenu addItem:self.switchMenuItem];
    
    [self.statusMenu addItem:[NSMenuItem separatorItem]];
    
    self.exitMenuItem = [[NSMenuItem alloc] initWithTitle:@"Exit" action:@selector(exit) keyEquivalent:@""];
    [self.exitMenuItem setTarget:self];
    [self.statusMenu addItem:self.exitMenuItem];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setAttributedTitle:[[NSAttributedString alloc] initWithString:@"zzz"]];
    [self.statusItem setHighlightMode:TRUE];
}

- (void) changeSwitchTitle:(NSString*)title andAction:(SEL)action
{
    [self.switchMenuItem setTitle:title];
    [self.switchMenuItem setAction:action];
}

- (void) changeStatusItemColor:(NSColor*)color
{
    NSString* title = [self.statusItem title];
    NSAttributedString* attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: color}];
    [self.statusItem setAttributedTitle:attributedTitle];
}

- (void) enableInsomnia
{
    IOPMAssertionID assertionId;
    
    IOReturn rc = IOPMAssertionCreateWithName(
        kIOPMAssertionTypePreventSystemSleep,
        kIOPMAssertionLevelOn,
        CFSTR("Insomnia.app"),
        &assertionId);
    
    if(rc != kIOReturnSuccess) {
        return;
    }
    
    self.powerManagementAssertionId = assertionId;
    
    [self changeSwitchTitle:@"Disable Insomnia" andAction:@selector(disableInsomnia)];
    [self changeStatusItemColor:[NSColor redColor]];
}

- (void) disableInsomnia
{
    if(IOPMAssertionRelease(self.powerManagementAssertionId) != kIOReturnSuccess) {
        return;
    }
    
    [self changeSwitchTitle:@"Enable Insomnia" andAction:@selector(enableInsomnia)];
    [self changeStatusItemColor:[NSColor blackColor]];
}

- (void) exit
{
    if(self.powerManagementAssertionId) {
        IOPMAssertionRelease(self.powerManagementAssertionId);
    }
    
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    [NSApp terminate:self];
}

@end
