//
//  VfxMainController.m
//  VF-X264
//
//  Created by John Paul Alcala on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VfxMainController.h"


@implementation VfxMainController

-(IBAction) selectDestination:(id)sender {
	NSLog(@"was clicked.");
	int result;
	
	NSURL *currentDestination=[destinationPath URL];
	
	NSOpenPanel *panel=[NSOpenPanel openPanel];
	[panel setAllowsMultipleSelection:NO];
	[panel setCanChooseDirectories:YES];
	[panel setCanChooseFiles:NO];
	[panel setTitle:@"Select Destination"];
	[panel setDirectoryURL:currentDestination];
	
	result=[panel runModal];
	
	if (result==NSOKButton) {
		NSArray *selected=[panel URLs];
		
		NSURL *selectedUrl=[selected lastObject];
		NSLog(@"Selected URL: %@", selectedUrl);
		
		[destinationPath setURL:selectedUrl];
	}
}

@end
