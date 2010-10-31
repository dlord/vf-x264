//
//  ProcessingController.h
//  VF-X264
//
//  Created by John Paul Alcala on 10/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ProcessingController : NSObject {
	BOOL isProcessing;
	
}

-(IBAction) startProcessing:(id)sender;
-(IBAction) stopProcessing:(id)sender;

-(BOOL) isProcessing;

-(void) readPipe:(NSNotification *) notification;

@end
