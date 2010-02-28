// 
//  NewsSource.m
//  FollowMyTeams
//
//  Created by surya gaddipati on 9/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewsSource.h"

#import "Story.h"
#import "FollowMyTeamsAppDelegate.h"
#import "ParsedStory.h"
@implementation NewsSource 
@synthesize continuation;
@dynamic selected;
@dynamic code;
@dynamic name;
@dynamic stories;

-(NSString*)logoImage{
	return [NSString stringWithFormat:@"%@.gif",[self.code lowercaseString] ];
}

-(void) clearStories{
		NSManagedObjectContext *managedObjectContext = ((FollowMyTeamsAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
	    for (Story* story in  self.stories) {
			[managedObjectContext deleteObject:story];
		}
	[managedObjectContext save:nil];
}

-(int) unReadCount{
	int unReadCount = 0;
	for(Story* story in self.stories){
		if([story isUnread]) unReadCount++;
	}
	return unReadCount;
}


-(BOOL) addFeedEntries :(NSArray*) feeds {
	
	BOOL foundNewItems = FALSE;
	for (ParsedStory* parsedStory	in feeds) {
		
	    if( ! [self feedEntriesContains : parsedStory] ){
			[parsedStory createStory:  ((FollowMyTeamsAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext newsSource:self];
			foundNewItems = TRUE;
		}
	}
	[((FollowMyTeamsAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext save:nil];
	return foundNewItems;
}

-(BOOL) feedEntriesContains :(ParsedStory*) parsedStory{
	Story* story;
	
	for( story in self.stories){
		
		if([ story.id isEqualToString:parsedStory.id]  ){
			return TRUE;
		}
	}
	return FALSE;		
}



@end
