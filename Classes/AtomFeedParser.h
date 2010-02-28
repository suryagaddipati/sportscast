//
//  AtomFeedParser.h
//  FutballNews
//
//  Created by surya gaddipati on 6/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ParsedStory.h"
#import "NewsSource.h"


@protocol FeedParserDelegate<NSObject>
-(void) feedFailed;
-(void) addFeedEntries : (NSArray*)feeds team: (NewsSource*)team fetchCount:(int)fetchCount;
@optional
-(void) finishedParsing;
@end


@interface AtomFeedParser : NSObject {
	
	NSXMLParser * rssParser;
	
	NSMutableArray * stories;
	
	ParsedStory * currentStory;
	NSString* currentElement;
	
	NSDateFormatter *dateFormat;
	
	id<FeedParserDelegate> controller;
	
	NSMutableData* feedData;
	NewsSource* team;
	
	int fetchCount;
	BOOL inSourceElement;
}
-(void) grabAtomFeed:(NewsSource *)currentteam sid:(NSString*)sid  controller:(id<FeedParserDelegate>) rutController  continuation:(NSString*)fromContinuation fetchCount:(int)fromFetchCount;
@property (nonatomic) int fetchCount;
@property (nonatomic, retain)NewsSource* team;

@end
