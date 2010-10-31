//
//  ProcessingController.m
//  VF-X264
//
//  Created by John Paul Alcala on 10/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProcessingController.h"
#import "SettingsFactory.h"
#import "Constants.h"

@implementation ProcessingController

-(IBAction) startProcessing:(id)sender {
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	NSBundle *mainBundle=[NSBundle mainBundle];
	NSString *mplayerPath=[mainBundle pathForResource:@"mplayer" ofType:nil inDirectory:@"Binaries"];
	NSString *x264Path=[mainBundle pathForResource:@"x264" ofType:nil inDirectory:@"Binaries"];
	NSString *mp4boxPath=[mainBundle pathForResource:@"MP4Box" ofType:nil inDirectory:@"Binaries"];
	NSString *midentifyPath=[mainBundle pathForResource:@"midentify" ofType:nil inDirectory:@"Binaries"];
	NSString *mplayerCodecsConfPath=[mainBundle pathForResource:@"codecs" ofType:@"conf"];
	NSString *mkfifoPath=@"/usr/bin/mkfifo";
	NSString *afconvertPath=@"/usr/bin/afconvert";
	
	NSMutableArray *midentifyArgs=[NSMutableArray array];
	[midentifyArgs addObject:@"/Users/dragonlord/tmp/test.mkv"];
	
	// identify the file before doing anything.
	NSTask *midentifyTask=[[NSTask alloc] init];
	NSPipe *midentifyPipe=[NSPipe pipe];
	[midentifyTask setLaunchPath:midentifyPath];
	[midentifyTask setArguments:midentifyArgs];
	[midentifyTask setCurrentDirectoryPath:[midentifyPath stringByDeletingLastPathComponent]];
	[midentifyTask setStandardOutput:midentifyPipe];
	[midentifyTask setStandardInput:[NSPipe pipe]];
	[midentifyTask launch];
	[midentifyTask waitUntilExit];
	//[midentifyTask release];
	
	// process video info into a dictionary
	NSData *midentifyOutput=[[midentifyPipe fileHandleForReading] readDataToEndOfFile];
	NSString *videoInfo=[[[NSString alloc] initWithData:midentifyOutput encoding:NSUTF8StringEncoding] autorelease];
	NSArray *videoInfoArray=[videoInfo componentsSeparatedByString:@"\n"];
	
	NSMutableDictionary *videoInfoDict=[NSMutableDictionary dictionary];
	for(NSString *infoSegment in videoInfoArray) {
		NSArray *segment=[infoSegment componentsSeparatedByString:@"="];
		if ([segment count]>1) {
			[videoInfoDict setObject:[segment objectAtIndex:1] forKey:[segment objectAtIndex:0]];
		}
	}
	
	NSLog(@"retrived fps: %@", [videoInfoDict valueForKey:@"ID_VIDEO_FPS"]);
	
	
	NSMutableArray *mkfifoArgs=[NSMutableArray array];
	//[mkfifoArgs addObject:[NSTemporaryDirectory() stringByAppendingPathComponent:@"video.y4m"]];
	[mkfifoArgs addObject:@"/Users/dragonlord/tmp2/video.y4m"];
	
	NSMutableArray *x264Args=[SettingsFactory x264GenericSettings];
	[x264Args addObjectsFromArray:[SettingsFactory x264SettingsForDevice:PHONE]];
	[x264Args addObject:@"-o"];
	[x264Args addObject:@"/Users/dragonlord/tmp2/output.264"];
	[x264Args addObject:@"/Users/dragonlord/tmp2/video.y4m"];
	
	NSMutableArray *mplayerArgs=[SettingsFactory mplayerGenericSettings];
	[mplayerArgs addObjectsFromArray:[SettingsFactory mplayerSettingsForDevice:PHONE]];
	[mplayerArgs addObject:@"-codecs-file"];
	[mplayerArgs addObject:mplayerCodecsConfPath];
	[mplayerArgs addObject:@"-quiet"];
	[mplayerArgs addObject:@"/Users/dragonlord/tmp/test.mkv"];
	
	NSMutableArray *afconvertArgs=[SettingsFactory afconvertSettings];
	
	NSMutableArray *mp4boxArgs=[SettingsFactory mp4boxSettings];
	[mp4boxArgs addObject:@"-fps"];
	[mp4boxArgs addObject:[videoInfoDict valueForKey:@"ID_VIDEO_FPS"]];
	[mp4boxArgs addObject:@"-new"];
	[mp4boxArgs addObject:@"/Users/dragonlord/tmp2/test.mp4"];
	
	NSTask *mkfifoTask=[[NSTask alloc] init];
	[mkfifoTask setLaunchPath:mkfifoPath];
	[mkfifoTask setArguments:mkfifoArgs];
	[mkfifoTask launch];
	[mkfifoTask waitUntilExit];
	[mkfifoTask release];
			
	NSTask *x264Task=[[NSTask alloc] init];
	[x264Task setLaunchPath:x264Path];
	[x264Task setArguments:x264Args];
	
	NSTask *mplayerTask=[[NSTask alloc] init];
	[mplayerTask setLaunchPath:mplayerPath];
	[mplayerTask setArguments:mplayerArgs];
	
	[x264Task launch];
	[mplayerTask launch];
	[mplayerTask waitUntilExit];
	[mplayerTask release];
	[x264Task release];
	
	NSTask *afconvertTask=[[NSTask alloc] init];
	[afconvertTask setLaunchPath:afconvertPath];
	[afconvertTask setArguments:afconvertArgs];
	[afconvertTask launch];
	[afconvertTask waitUntilExit];
	[afconvertTask release];
	
	NSTask *mp4boxTask=[[NSTask alloc] init];
	[mp4boxTask setLaunchPath:mp4boxPath];
	[mp4boxTask setArguments:mp4boxArgs];
	[mp4boxTask launch];
	[mp4boxTask waitUntilExit];
	[mp4boxTask release];
	
	NSLog(@"End of start method.");
	
	[pool drain];
}

-(IBAction) stopProcessing:(id)sender {
}

-(BOOL) isProcessing {
	return isProcessing;
}

-(void) readPipe:(NSNotification *) notification {
	
}

@end
