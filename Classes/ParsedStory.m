//
//  ParsedStory.m
//  FollowMyTeams
//
//  Created by surya gaddipati on 8/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ParsedStory.h"
#import "NSDateHelper.h"
#import "NewsSource.h"
@implementation ParsedStory
@synthesize read,summary,pubDate,title,link,id,content,source;


-(Story*) createStory :(NSManagedObjectContext*) managedObjectContext newsSource:(NewsSource*) newsSource{
	Story* story  =     (Story*)[NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext: managedObjectContext];
	[story setId:self.id];
	[story setRead: self.read];
	[story setSummary:self.summary];
	[story setPubDate:self.pubDate];
	[story setTitle:self.title];
	[story setLink:self.link];

	[story setContent:self.content];
	
	[story setSource:self.source];
	[story setNewSource:newsSource];
	[story setRead:[NSNumber numberWithInt : 0 ]];
	[newsSource addStoriesObject:story];
	return story;
}

-(BOOL) isOld{
	NSTimeInterval fourdays = 24 * 60 * 60*4;
	NSDate *today = [NSDate date];
	NSDate* fourDaysBeforeNow =   [today addTimeInterval:-fourdays];
    return [self.pubDate compare:fourDaysBeforeNow] == NSOrderedAscending;	
}
@end
