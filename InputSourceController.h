//
//  InputSourceController.h
//  VF-X264
//
//  Created by John Paul Alcala on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface InputSourceController : NSObject {
	NSMutableArray *inputFiles;
	IBOutlet NSTableView *inputFilesTableView;
}

@property(retain) NSArray *inputFiles;

-(IBAction) addInputFiles:(id)sender;
-(IBAction) removeInputFiles:(id)sender;

@end
