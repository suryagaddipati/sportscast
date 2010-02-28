//
//  RootViewController.h
//  FutballNews
//
//  Created by surya gaddipati on 6/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Three20/Three20.h"
#import <CoreData/CoreData.h>
#import "NewsSource.h"
#import "GoogleReaderLogin.h"
#import "AtomFeedParser.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface RootViewController : UITableViewController<GoogleReaderLoginDelegate,FeedParserDelegate,NSFetchedResultsControllerDelegate> {

	int loadCount;

	NSManagedObjectContext *managedObjectContext;
	NSString* sid;
	NSArray* selectedTeams;
	
	NSFetchedResultsController *fetchedResultsController;
	
	ASINetworkQueue* networkQueue;
}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain)	NSArray* selectedTeams;
@property (nonatomic, retain) 	NSString* sid;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	 


-(void) addFeedEntries : (NSArray*)feeds team: (NewsSource*)team fetchCount:(int)fetchCount;


-(void) incrementLoadCount;

	@end
