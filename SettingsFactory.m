//
//  SettingsFactory.m
//  VF-X264
//
//  Created by John Paul Alcala on 10/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsFactory.h"
#import "Constants.h"

@implementation SettingsFactory

+(NSMutableArray *) x264SettingsForProfile:(NSString *) profileName {
	NSMutableArray *settings=[NSMutableArray array];
	
	if (profileName==X264_BASELINE) {
		[settings addObject:@"--profile"];
		[settings addObject:@"baseline"];
		[settings addObject:@"--no-cabac"];
		[settings addObject:@"--bframes"];
		[settings addObject:@"0"];
		[settings addObject:@"--no-8x8dct"];
		[settings addObject:@"--cqm"];
		[settings addObject:@"flat"];
	} else if (profileName==X264_MAIN) {
		[settings addObject:@"--profile"];
		[settings addObject:@"main"];
		[settings addObject:@"--no-8x8dct"];
		[settings addObject:@"--cqm"];
		[settings addObject:@"flat"];
	} else if (profileName==X264_HIGH) {
		[settings addObject:@"--profile"];
		[settings addObject:@"high"];
	}
	
	return settings;
}

+(NSMutableArray *) x264SettingsForDevice:(NSString *) deviceName {
	NSMutableArray *settings=[NSMutableArray array];
	
	if (deviceName==IPOD) {
		[settings addObjectsFromArray:[SettingsFactory x264SettingsForProfile:X264_BASELINE]];
		[settings addObject:@"--level"];
		[settings addObject:@"3"];
		[settings addObject:@"--vbv-bufsize"];
		[settings addObject:@"720"];
		[settings addObject:@"--vbv-maxrate"];
		[settings addObject:@"720"];
	} else if (deviceName==IPHONE) {
		// for now, they're the same. may change in the future.
		[settings addObjectsFromArray:[SettingsFactory x264SettingsForProfile:X264_BASELINE]];
		[settings addObject:@"--level"];
		[settings addObject:@"3"];
		[settings addObject:@"--vbv-bufsize"];
		[settings addObject:@"720"];
		[settings addObject:@"--vbv-maxrate"];
		[settings addObject:@"720"];
	} else if (deviceName==PS3) {
		[settings addObjectsFromArray:[SettingsFactory x264SettingsForProfile:X264_HIGH]];
		[settings addObject:@"--level"];
		[settings addObject:@"4.1"];
		[settings addObject:@"--vbv-bufsize"];
		[settings addObject:@"1500"];
		[settings addObject:@"--vbv-maxrate"];
		[settings addObject:@"1500"];
	} else if (deviceName==PSP) {
		[settings addObjectsFromArray:[SettingsFactory x264SettingsForProfile:X264_MAIN]];
		[settings addObject:@"--level"];
		[settings addObject:@"2.1"];
		[settings addObject:@"--vbv-bufsize"];
		[settings addObject:@"720"];
		[settings addObject:@"--vbv-maxrate"];
		[settings addObject:@"720"];
	} else if (deviceName==PHONE) {
		[settings addObjectsFromArray:[SettingsFactory x264SettingsForProfile:X264_BASELINE]];
		[settings addObject:@"--level"];
		[settings addObject:@"1.1"];
		[settings addObject:@"--vbv-bufsize"];
		[settings addObject:@"720"];
		[settings addObject:@"--vbv-maxrate"];
		[settings addObject:@"720"];
	}
	
	return settings;
}

+(NSMutableArray *) x264GenericSettings {
	NSMutableArray *settings=[NSMutableArray array];
	
	[settings addObject:@"--force-cfr"];
	[settings addObject:@"--crf"];
	[settings addObject:@"18"];
	[settings addObject:@"--partitions"];
	[settings addObject:@"p8x8,b8x8,i8x8,i4x4"];
	[settings addObject:@"--me"];
	[settings addObject:@"umh"];
	[settings addObject:@"--subme"];
	[settings addObject:@"7"];
	[settings addObject:@"--threads"];
	[settings addObject:@"auto"];
	[settings addObject:@"--no-fast-pskip"];
	[settings addObject:@"--quiet"];
	
	return settings;
}

+(NSMutableArray *) mplayerSettingsForDevice:(NSString *) deviceName {
	NSMutableArray *settings=[NSMutableArray array];
	
	if (deviceName==IPOD) {
		[settings addObject:@"-vf"];
		[settings addObject:@"dsize=480:320:0,scale=0:0,harddup"];
	} else if (deviceName==IPHONE) {
		[settings addObject:@"-vf"];
		[settings addObject:@"dsize=640:480:0,scale=0:0,harddup"];
	} else if (deviceName==PS3) {
		[settings addObject:@"-vf"];
		[settings addObject:@"harddup"];
	} else if (deviceName==PSP) {
		[settings addObject:@"-vf"];
		[settings addObject:@"dsize=480:272:0,scale=0:0,harddup"];
	} else if (deviceName==PHONE) {
		[settings addObject:@"-vf"];
		[settings addObject:@"dsize=320:240:0,scale=0:0,harddup"];
	}
	
	return settings;
}

+(NSMutableArray *) mplayerGenericSettings {
	NSMutableArray *settings=[NSMutableArray array];

	[settings addObject:@"-benchmark"];
	[settings addObject:@"-correct-pts"];
	[settings addObject:@"-vo"];
	[settings addObject:@"yuv4mpeg:file=/Users/dragonlord/tmp2/video.y4m"];
	[settings addObject:@"-alang"];
	[settings addObject:@"jpn,jp,eng,en"];
	[settings addObject:@"-ao"];
	[settings addObject:@"pcm:waveheader:file=/Users/dragonlord/tmp2/audio.wav:fast"];
	[settings addObject:@"-af"];
	[settings addObject:@"pan=2:1:0:0:1:1:0:0:1:0.5:0.5:1:1"];
	[settings addObject:@"-sid"];
	[settings addObject:@"0"];
	[settings addObject:@"-sws"];
	[settings addObject:@"9"];
	[settings addObject:@"-ass"];
	
	return settings;
}

+(NSMutableArray *) afconvertSettings {
	NSMutableArray *settings=[NSMutableArray array];
	
	[settings addObject:@"-v"];
	[settings addObject:@"-f"];
	[settings addObject:@"m4af"];
	[settings addObject:@"-d"];
	[settings addObject:@"aac"];
	[settings addObject:@"-q"];
	[settings addObject:@"64"];
	[settings addObject:@"/Users/dragonlord/tmp2/audio.wav"];
	[settings addObject:@"/Users/dragonlord/tmp2/audio.mp4"];
	
	return settings;
}

+(NSMutableArray *) mp4boxSettings {
	NSMutableArray *settings=[NSMutableArray array];
	
	[settings addObject:@"-add"];
	[settings addObject:@"/Users/dragonlord/tmp2/output.264"];
	[settings addObject:@"-add"];
	[settings addObject:@"/Users/dragonlord/tmp2/audio.mp4"];
	
	return settings;
}

@end
