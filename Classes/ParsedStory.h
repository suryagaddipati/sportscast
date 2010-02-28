

//
//  ParsedStory.h
//  FollowMyTeams
//
//  Created by surya gaddipati on 8/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Story.h"
#import "NewsSource.h"

@interface ParsedStory : NSObject {
	NSNumber * read;
	NSString * summary;
	NSDate * pubDate;
	NSString * title;
	NSString * link;
	NSString * logo;
	NSString * id;
	NSString* content;
	NSString* source;
}
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * source;

@property (nonatomic, retain) NSString * id;

-(Story*) createStory :(NSManagedObjectContext*) managedObjectContext newsSource:(NewsSource*) newsSource;
-(BOOL) isOld;
@end
