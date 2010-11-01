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

@interface ProcessingController()

-(void) startBackgroundProcessing;
-(NSDictionary *) identifyFile:(NSString *)filename;
-(void) mkfifo;
-(void) runX264;
-(void) extractAudioAndVideoFromFile:(NSString *)filename;
-(void) convertAudioToAac;
-(void) createMP4PackageUsingFilename:(NSString *)filename andParams:(NSDictionary *)params;

@end


@implementation ProcessingController

-(IBAction) startProcessing:(id)sender {
	[self performSelectorInBackground:@selector(startBackgroundProcessing) withObject:nil];
}

-(void) startBackgroundProcessing {
	isProcessing=YES;

	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	NSArray *inputFiles=inputSourceController.inputFiles;
	
	for(NSURL *file in inputFiles) {
		NSDictionary *fileParams=[self identifyFile:[file path]];
		
		if ([fileParams count]>1 && isProcessing) {
			[self mkfifo];
		}
		
		if (isProcessing) {
			[self runX264];
			[self extractAudioAndVideoFromFile:[file path]];
		}
		
		if (isProcessing) {
			[self convertAudioToAac];
		}
		
		if (isProcessing) {
			[self createMP4PackageUsingFilename:[file lastPathComponent] andParams:fileParams];
		}
	}
	
	[pool drain];
}

-(NSDictionary *) identifyFile:(NSString *)filename {
	NSBundle *mainBundle=[NSBundle mainBundle];
	NSString *midentifyPath=[mainBundle pathForResource:@"midentify" ofType:nil inDirectory:@"Binaries"];
	
	NSMutableArray *midentifyArgs=[NSMutableArray array];
	[midentifyArgs addObject:filename];
	
	// identify the file before doing anything.
	NSTask *midentifyTask=[[NSTask alloc] init];
	NSPipe *midentifyPipe=[NSPipe pipe];
	[midentifyTask setLaunchPath:midentifyPath];
	[midentifyTask setArguments:midentifyArgs];
	[midentifyTask setCurrentDirectoryPath:[midentifyPath stringByDeletingLastPathComponent]];
	[midentifyTask setStandardOutput:midentifyPipe];
	[midentifyTask setStandardInput:[NSPipe pipe]];

	[self addRunningTask:midentifyTask];
	[midentifyTask launch];
	[midentifyTask waitUntilExit];
	[self clearRunningTasks];
	
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
	
	return videoInfoDict;
}

-(void) mkfifo {
	NSString *mkfifoPath=@"/usr/bin/mkfifo";
	NSMutableArray *mkfifoArgs=[NSMutableArray array];
	//[mkfifoArgs addObject:[NSTemporaryDirectory() stringByAppendingPathComponent:@"video.y4m"]];
	[mkfifoArgs addObject:@"/Users/dragonlord/tmp2/video.y4m"];
	
	NSTask *task=[[NSTask alloc] init];
	[task setLaunchPath:mkfifoPath];
	[task setArguments:mkfifoArgs];
	
	[self addRunningTask:task];
	[task launch];
	[task waitUntilExit];
	[self clearRunningTasks];
}

-(void) runX264 {
	NSBundle *mainBundle=[NSBundle mainBundle];
	NSString *x264Path=[mainBundle pathForResource:@"x264" ofType:nil inDirectory:@"Binaries"];
	
	NSMutableArray *x264Args=[SettingsFactory x264SettingsForDevice:[targetFormatDropdown titleOfSelectedItem]];
	
	NSTask *task=[[NSTask alloc] init];
	[task setLaunchPath:x264Path];
	[task setArguments:x264Args];
	
	[self addRunningTask:task];
	[task launch];
}

-(void) extractAudioAndVideoFromFile:(NSString *)filename {
	NSBundle *mainBundle=[NSBundle mainBundle];
	NSString *mplayerPath=[mainBundle pathForResource:@"mplayer" ofType:nil inDirectory:@"Binaries"];
	
	NSMutableArray *mplayerArgs=[SettingsFactory mplayerSettingsForDevice:[targetFormatDropdown titleOfSelectedItem]];
	[mplayerArgs addObject:filename];
	
	NSTask *task=[[NSTask alloc] init];
	[task setLaunchPath:mplayerPath];
	[task setArguments:mplayerArgs];

	[self addRunningTask:task];
	[task launch];
	[task waitUntilExit];
	[self clearRunningTasks];
}

-(void) convertAudioToAac {
	NSString *afconvertPath=@"/usr/bin/afconvert";
	
	NSMutableArray *afconvertArgs=[SettingsFactory afconvertSettings];
	
	NSTask *task=[[NSTask alloc] init];
	[task setLaunchPath:afconvertPath];
	[task setArguments:afconvertArgs];

	[self addRunningTask:task];
	[task launch];
	[task waitUntilExit];
	[self clearRunningTasks];
}

-(void) createMP4PackageUsingFilename:(NSString *)filename andParams:(NSDictionary *)params {
	NSBundle *mainBundle=[NSBundle mainBundle];
	NSString *mp4boxPath=[mainBundle pathForResource:@"MP4Box" ofType:nil inDirectory:@"Binaries"];
	
	NSMutableArray *mp4boxArgs=[SettingsFactory mp4boxSettings];
	[mp4boxArgs addObject:@"-fps"];
	[mp4boxArgs addObject:[params valueForKey:@"ID_VIDEO_FPS"]];
	[mp4boxArgs addObject:@"-new"];
	
	NSString *destinationFile=[[[destinationPath URL] path] stringByAppendingPathComponent:filename];
	destinationFile=[[destinationFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"mp4"];
	
	[mp4boxArgs addObject:destinationFile];
	
	NSTask *task=[[NSTask alloc] init];
	[task setLaunchPath:mp4boxPath];
	[task setArguments:mp4boxArgs];
	
	[self addRunningTask:task];
	[task launch];
	[task waitUntilExit];
	[self clearRunningTasks];
}

-(IBAction) stopProcessing:(id)sender {
	@synchronized(self) {
		isProcessing=NO;
	}
	
	@synchronized(self) {
		for(NSTask *task in runningTasks) {
			[task terminate];
		}
	}
	
	[self clearRunningTasks];
}

-(void) addRunningTask:(NSTask *)task {
	@synchronized(self) {
		if (runningTasks==nil) {
			runningTasks=[NSMutableArray array];
			[runningTasks retain];
		}
		
		[runningTasks addObject:task];
	}
}

-(void) clearRunningTasks {
	@synchronized(self) {
		if (runningTasks==nil) {
			runningTasks=[NSMutableArray array];
			[runningTasks retain];
		}
		
		for(NSTask *task in runningTasks) {
			[task release];
		}
		
		[runningTasks removeAllObjects];
	}
}

-(BOOL) isProcessing {
	return isProcessing;
}

@end
