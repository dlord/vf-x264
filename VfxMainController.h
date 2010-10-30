//
//  VfxMainController.h
//  VF-X264
//
//  Created by John Paul Alcala on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface VfxMainController : NSObject {
	IBOutlet NSPathControl *destinationPath;
}

-(IBAction) selectDestination:(id)sender;

-(IBAction) testPlay:(id)sender;

@end
