//
//  AtomFeedParser.m
//  FutballNews
//
//  Created by surya gaddipati on 6/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AtomFeedParser.h"
#import "RootViewController.h"


@implementation AtomFeedParser
@synthesize fetchCount,team;



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
		[feedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    rssParser = [[NSXMLParser alloc] initWithData:feedData];

    [rssParser setDelegate:self];
	
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	
    [rssParser parse];
	
	[controller addFeedEntries:stories team:team fetchCount:fetchCount];
	
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[controller feedFailed];
}





-(void) grabAtomFeed:(NewsSource *)currentteam sid:(NSString*)sid  controller:(id<FeedParserDelegate>) rutController  continuation:(NSString*)fromContinuation fetchCount:(int)fromFetchCount {
	self.team = currentteam;
	controller = rutController;
	feedData = [NSMutableData new];
	self.fetchCount = fromFetchCount;
	
	NSString* urlAddress = [NSString stringWithFormat: @"http://www.google.com/reader/atom/user/-/label/%@?n=%d",[team.code lowercaseString] ,fromFetchCount];
	if(team.continuation != nil){
		urlAddress = [ NSString stringWithFormat:@"%@&c=%@", urlAddress,fromContinuation];
	}
	
	NSURL* url = [NSURL URLWithString: urlAddress ];
	
	NSLog(@" Fetching : %@", urlAddress);
	NSMutableURLRequest* urlRequest = [ [[NSMutableURLRequest alloc]
									   initWithURL:url] autorelease];
	[urlRequest setHTTPMethod:@"GET"];
	[urlRequest setValue:[NSString stringWithFormat:@"SID=%@",sid ] forHTTPHeaderField: @"Cookie"];	
	NSURLConnection *connectionResponse = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self]autorelease];
	if(connectionResponse == nil){
		[controller feedFailed];
	}
	
	dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss'Z'"]; // 2009-07-31T03:24:53Z
	
	
	stories = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
 	currentElement = [elementName copy];
	if([elementName isEqualToString:@"link"] && currentStory != nil && currentStory.link == nil){
		[currentStory setLink : [attributeDict objectForKey:@"href"]];
   	}
	if ([elementName isEqualToString:@"entry"]) {
		currentStory =   [ParsedStory new]; 
	}
	
	if ([elementName isEqualToString:@"source"]) {
		inSourceElement= TRUE;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	if ([elementName isEqualToString:@"entry"]) {
	    if( ![currentStory isOld]){
			[stories addObject: currentStory];
		}
		[currentStory release];
		
	}
	if ([elementName isEqualToString:@"source"]) {
		inSourceElement= FALSE;
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	
	if([currentElement isEqualToString:@"gr:continuation"]){
		team.continuation = string;
	   }
	
	
	if ([currentElement isEqualToString:@"id"] &&  currentStory != nil && currentStory.id == nil )  {
			[currentStory  setId: string];
	}
	
	if ([currentElement isEqualToString:@"title"] && currentStory.title == nil) {
		[currentStory  setTitle: string];
	}
	if ([currentElement isEqualToString:@"title"] && inSourceElement) {
		[currentStory  setSource: string];
	}
	
	
	if ([currentElement isEqualToString:@"updated"] && currentStory.pubDate == nil) {
		[currentStory setPubDate: [ dateFormat dateFromString:string]];
		
	}
	if ([currentElement isEqualToString:@"summary"] ) {
		if( currentStory.summary == nil) {
			[currentStory setSummary : [ NSMutableString stringWithString:string]];
		}else{
			[[currentStory summary]  appendString:string];
		}
	}
	if ([currentElement isEqualToString:@"content"] ) {
		if( currentStory.content == nil) {
			[currentStory setContent : [ NSMutableString stringWithString:string]];
		}else{
			[[currentStory content]  appendString:string];
		}
	}
	
}



-(void) dealloc{
	[ rssParser release];
	[feedData release];
	[ stories release];
	[dateFormat release];
	[team release];
	[super dealloc];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
}



@end
