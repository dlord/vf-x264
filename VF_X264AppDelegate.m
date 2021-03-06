//
//  VF_X264AppDelegate.m
//  VF-X264
//
//  Created by John Paul Alcala on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VF_X264AppDelegate.h"
#import "Constants.h"

@implementation VF_X264AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	NSURL *url=[NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
	
	[destinationPath setURL:url];
	[destinationPath sizeToFit];
	
	[targetFormatDropdown removeAllItems];
	[targetFormatDropdown addItemWithTitle:IPHONE];
	[targetFormatDropdown addItemWithTitle:IPOD];
	[targetFormatDropdown addItemWithTitle:PS3];
	[targetFormatDropdown addItemWithTitle:PSP];
	[targetFormatDropdown addItemWithTitle:PHONE];
}

@end
