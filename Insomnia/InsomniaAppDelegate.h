#import <Cocoa/Cocoa.h>
#import <IOKit/pwr_mgt/IOPMLib.h>

@interface InsomniaAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property IOPMAssertionID powerManagementAssertionId;
@property (retain) NSMenu* statusMenu;
@property (retain) NSMenuItem* switchMenuItem;
@property (retain) NSMenuItem* exitMenuItem;
@property (retain) NSStatusItem* statusItem;

@end
