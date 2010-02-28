// 
//  Story.m
//  FollowMyTeams
//
//  Created by surya gaddipati on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Story.h"

#import "NewsSource.h"


@implementation Story 

@dynamic read;
@dynamic summary;
@dynamic pubDate;
@dynamic content;
@dynamic title;
@dynamic link;
@dynamic id;
@dynamic newSource;
@dynamic source;
-(NSString*) getContent{
	if(self.content == nil && self.summary == nil) return NSLocalizedString(@"Summary Not Available.", @"");
	return self.content==nil?self.summary:self.content;
}
-(NSString*) getSummary{
	return self.summary==nil?self.content:self.summary;
}

-(NSString*) getDetailUrl{
	return  self.link;
}
-(BOOL) isUnread{
	return [ self.read intValue] ==0;
}

-(BOOL) isTwitter{
	return [ self.source hasPrefix:@"Twitter"];
}


-(BOOL) isOld{
	NSTimeInterval fourdays = 24 * 60 * 60*4;
	NSDate *today = [NSDate date];
	NSDate* fourDaysBeforeNow =   [today addTimeInterval:fourdays];
	return [self.pubDate compare:fourDaysBeforeNow] == NSOrderedAscending;	
}
@end
