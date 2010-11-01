//
//  ProcessingController.h
//  VF-X264
//
//  Created by John Paul Alcala on 10/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InputSourceController.h"

@interface ProcessingController : NSObject {
	BOOL isProcessing;
	NSMutableArray *runningTasks;
	
	IBOutlet InputSourceController *inputSourceController;
	IBOutlet NSPopUpButton *targetFormatDropdown;
	IBOutlet NSPathControl *destinationPath;
}

-(IBAction) startProcessing:(id)sender;
-(IBAction) stopProcessing:(id)sender;

-(void) addRunningTask:(NSTask *)task;
-(void) clearRunningTasks;

-(BOOL) isProcessing;

@end
