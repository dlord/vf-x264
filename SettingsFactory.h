//
//  SettingsFactory.h
//  VF-X264
//
//  Created by John Paul Alcala on 10/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SettingsFactory : NSObject {

}

+(NSMutableArray *) x264SettingsForProfile:(NSString *) profileName;

+(NSMutableArray *) x264SettingsForDevice:(NSString *) deviceName;

+(NSMutableArray *) x264GenericSettings;

+(NSMutableArray *) mplayerSettingsForDevice:(NSString *) deviceName;

+(NSMutableArray *) mplayerGenericSettings;

+(NSMutableArray *) afconvertSettings;

+(NSMutableArray *) mp4boxSettings;

@end
