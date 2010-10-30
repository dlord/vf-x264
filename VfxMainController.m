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

-(IBAction) testPlay:(id)sender {
	NSBundle *mainBundle=[NSBundle mainBundle];
	NSString *mplayerPath=[mainBundle pathForResource:@"mplayer" ofType:nil inDirectory:@"Binaries"];
	NSString *mplayerCodecsConfPath=[mainBundle pathForResource:@"codecs" ofType:@"conf"];
	
	NSLog(@"mplayer location: %@", mplayerPath);
	NSLog(@"mplayer config location: %@", mplayerCodecsConfPath);
	//NSLog(@"param: %@", [NSString stringWithFormat:@"-codecs-file \"%@\"", mplayerCodecsConfPath]);
		
	NSMutableArray *mplayerArgs=[NSMutableArray array];
	[mplayerArgs addObject:@"-codecs-file"];
	[mplayerArgs addObject:mplayerCodecsConfPath];
	[mplayerArgs addObject:@"-really-quiet"];
	[mplayerArgs addObject:@"-vo"];
	[mplayerArgs addObject:@"corevideo:buffer_name=mplayerVFX"];
	[mplayerArgs addObject:@"/Users/dragonlord/tmp/test.mp4"];
	
	NSTask *mplayerTask=[[NSTask alloc] init];
	[mplayerTask setStandardInput:[NSPipe pipe]];
	[mplayerTask setStandardOutput:[NSPipe pipe]];
	[mplayerTask setStandardError:[NSPipe pipe]];
	
	[mplayerTask setArguments:mplayerArgs];
	[mplayerTask setLaunchPath:mplayerPath];
	
	[mplayerTask launch];
	[mplayerTask release];
}

@end
