//
//  InputSourceController.m
//  VF-X264
//
//  Created by John Paul Alcala on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InputSourceController.h"


@implementation InputSourceController

@synthesize inputFiles;

- (int)numberOfRowsInTableView:(NSTableView *)aTable {
	return [inputFiles count];
}

- (id)tableView:(NSTableView *)aTable objectValueForTableColumn:(NSTableColumn *)aCol row:(int)aRow {
	NSURL *url=[inputFiles objectAtIndex:aRow];
	NSString *columnName=[aCol identifier];
	
	if ([columnName isEqualToString:@"filename"]) {
		return [url lastPathComponent];
	} else {
		return nil;
	}
}

-(IBAction) addInputFiles:(id)sender {
	NSOpenPanel *panel=[NSOpenPanel openPanel];
	
	NSURL *homeFolder=[NSURL URLWithString:NSHomeDirectory()];
	
	[panel setAllowsMultipleSelection:YES];
	[panel setCanChooseFiles:YES];
	[panel setCanChooseDirectories:NO];
	[panel setTitle:@"Select Source Files"];
	[panel setDirectoryURL:homeFolder];
	
	int result=[panel runModal];
	
	if (inputFiles==nil) {
		NSMutableArray *a=[NSMutableArray array];
		self.inputFiles=a;		
	}
	
	if (result==NSOKButton) {
		NSArray *selected=[panel URLs];
		[inputFiles addObjectsFromArray:selected];
		
		[inputFilesTableView reloadData];
	}
}

-(IBAction) removeInputFiles:(id)sender {
	NSIndexSet *selectedRows=[inputFilesTableView selectedRowIndexes];
	NSMutableArray *forRemoval=[NSMutableArray array];
	
	NSUInteger index=[selectedRows firstIndex];
	
	while (index!=NSNotFound) {
		[forRemoval addObject:[inputFiles objectAtIndex:index]];
		index=[selectedRows indexGreaterThanIndex:index];
	}
	
	[inputFiles removeObjectsInArray:forRemoval];
	[inputFilesTableView reloadData];
	[inputFilesTableView deselectAll:self];
}

@end
