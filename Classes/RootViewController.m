

#import "RootViewController.h"
#import "FollowMyTeamsAppDelegate.h"
#import "AtomFeedParser.h"
#import "StoryDetailController.h"
#import "Story.h"

#import "GoogleReaderLogin.h"
#import "ParsedStory.h"
#import "StorySummaryViewController.h"
#import "NSDateHelper.h"
#import "UITableViewHelper.h"
#import "UIViewControllerHelper.h"
#import "TTSearchlightLabel+FeedReader.h"

#import "NSArrayHelper.h"
#import "UITableViewCell+FeedReader.h"
#import "StoryCell.h"
#define  progressLabel [ TTSearchlightLabel instance]


@interface RootViewController()

-(void) loadFeedsInTableView;
-(void) setUnReadCount:(int) count;
-(void) decrementUnReadCount;
-(void) incrementUnReadCount;
-(void) fetchFeedsForTeam: (NewsSource*) team fetchCount:(int)fetchCount;
-(void) deleteStaleEntries;

@end


@implementation RootViewController
@synthesize   managedObjectContext , sid, selectedTeams ,fetchedResultsController;

#pragma mark -

#pragma mark GoogleReaderLogin
-(void)failed{
	[progressLabel failedUpdate];
}

-(void) success:(NSString*)sidId{
	self.sid = sidId;
	for( NewsSource* team in selectedTeams){
		[self fetchFeedsForTeam:team fetchCount:6];
	}
	
}
#pragma mark -

#pragma mark FeedReader Methods
-(void) feedFailed{
	[self incrementLoadCount];
}

-(void) addFeedEntries : (NSArray*)feeds team: (NewsSource*)team fetchCount:(int)fetchCount {
	
	
	if( [team addFeedEntries:feeds] ){
		[self fetchFeedsForTeam:team fetchCount:fetchCount*2];		
	}else{
		[self incrementLoadCount];
	}
}


#pragma mark -


#pragma mark TableView Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[fetchedResultsController sections] count];
    
	if (count == 0) {
		count = 1;
	}
	
    return count;
} 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
	
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Story* currentStory = [fetchedResultsController objectAtIndexPath:indexPath];
	static NSString *CellIdentifier = @"StoryCell";
	
	StoryCell *timeZoneCell = (StoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (timeZoneCell == nil) {
		timeZoneCell = [[[StoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		timeZoneCell.frame = CGRectMake(0.0, 0.0, 320.0, 95);
	}
	[timeZoneCell setStory:currentStory];
	return timeZoneCell;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 95 ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	Story* currentStory =  [fetchedResultsController objectAtIndexPath:indexPath];
	currentStory.read = [NSNumber numberWithBool: TRUE];
	[ managedObjectContext save:nil];
	UIViewController* anotherViewController = [[StorySummaryViewController alloc] initWithNibName:@"StorySummaryViewController" bundle:nil story: currentStory ];
	
	
	[self.navigationController pushViewController:anotherViewController animated:YES];
	[anotherViewController release];


	
}

#pragma mark -


-(void) fetchFeedsForTeam: (NewsSource*) team  fetchCount:(int)fetchCount{
	AtomFeedParser* parser = [AtomFeedParser new];
	[parser grabAtomFeed: team sid:sid controller : self continuation:team.continuation fetchCount:fetchCount ];	
	[parser release];
}


- (void)viewWillDisappear:(BOOL)animated{
	[progressLabel removeFromSuperview];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	FollowMyTeamsAppDelegate* delegate = [UIApplication sharedApplication].delegate;
	if( delegate.changedSelection ){
		delegate.changedSelection = FALSE;
		NSFetchRequest *fetchRequest  = [delegate.managedObjectModel fetchRequestTemplateForName:@"fetchSelectedSources"];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsSource" inManagedObjectContext:delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
		NSError *error = nil;
		self.selectedTeams =  [managedObjectContext executeFetchRequest:fetchRequest error:&error] ;
		[self.tableView setContentUnavailable:[selectedTeams isEmpty]];
		if([selectedTeams isEmpty]){
			[self setUnReadCount:0];
		}else{
			[self loadFeedsInTableView];
		}
		
				
	}
}

-(void) deleteStaleEntries{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	NSSortDescriptor *sortDescriptorTime = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorTime, nil];
	[request setSortDescriptors:sortDescriptors];
	
	NSDate* oldDate = [NSDate dateFromOffSetDays:-3];
	NSPredicate *predicate = [NSPredicate predicateWithFormat: @" pubDate < %@ ",oldDate ];
	[request setPredicate:predicate];
	
	NSArray *staleStories = [managedObjectContext executeFetchRequest:request error:nil];
	
	
	for(Story* story	in staleStories){
		[managedObjectContext deleteObject:story];
	}
	
	
}

-(void) loadFeedsInTableView{
	loadCount = 0;	
	
	[[[GoogleReaderLogin alloc]init:self]autorelease];
	[progressLabel startedReading];	
}




-(void) incrementLoadCount
{
	loadCount++;
	
	if( [selectedTeams count] ==loadCount){
		[progressLabel doneReading];
		[networkQueue cancelAllOperations];
		[networkQueue setRequestDidFinishSelector:@selector(storyDownloadComplete:)];
		[networkQueue setDelegate:self];
	}
}
-(void) storyDownloadComplete:(ASIHTTPRequest *)request{
	//NSLog(@"%@",[[[NSString alloc] initWithData:[request responseData] encoding:NSASCIIStringEncoding] autorelease] );
}

-(void) setUnReadCount:(int) count{
	FollowMyTeamsAppDelegate* delegate = [UIApplication sharedApplication].delegate;
	((UITabBarItem *)[delegate.tabBarController.tabBar.items objectAtIndex:0]).badgeValue = [NSString stringWithFormat:@"%d",count];
}

-(void) decrementUnReadCount{
	FollowMyTeamsAppDelegate* delegate = [UIApplication sharedApplication].delegate;
	NSString* unreadCount =	  ((UITabBarItem *)[delegate.tabBarController.tabBar.items objectAtIndex:0]).badgeValue;
	[self setUnReadCount: [unreadCount intValue]-1];
}
-(void) incrementUnReadCount{
	FollowMyTeamsAppDelegate* delegate = [UIApplication sharedApplication].delegate;
	NSString* unreadCount =	  ((UITabBarItem *)[delegate.tabBarController.tabBar.items objectAtIndex:0]).badgeValue;
	[self setUnReadCount: [unreadCount intValue]+1];
}

-(void) updateReadCount{
	[  self setUnReadCount: [self getUnreadCount] ];
}





- (void)viewDidLoad
{
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target:self
											   action:@selector(loadFeedsInTableView)] autorelease];
	
	FollowMyTeamsAppDelegate* delegate = [UIApplication sharedApplication].delegate;
	self.managedObjectContext = delegate.managedObjectContext;
	
	networkQueue = [[ASINetworkQueue alloc] init];
	
		[ self deleteStaleEntries];	
	
	[[self  fetchedResultsController] performFetch:nil];
	[  self setUnReadCount: [self getUnreadCount] ];
	


}

-(int) getUnreadCount{
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Story"
											  inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	// Assume salaryLimit defined as an NSNumber variable.
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"read == %d", 00];
	[request setPredicate:predicate];
		
	
	NSError *error = nil;
		NSArray *unreadStories = [managedObjectContext executeFetchRequest:request error:&error];
	if (error) {
		NSLog(@"Error %@" ,error);
		
	}

	return [unreadStories count];
}


- (void)dealloc {
	
	[managedObjectContext release];
	[networkQueue release];
	[progressLabel release];
    [super dealloc];
}



#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController == nil) {
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:managedObjectContext];
		[request setEntity:entity];
		
		NSSortDescriptor *sortDescriptorTime = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorTime, nil];
		[request setSortDescriptors:sortDescriptors];
				
        NSFetchedResultsController *aFetchedResultsController = [ [NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Stories"];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController = aFetchedResultsController;
        
        [aFetchedResultsController release];
        [request release];
		
		[sortDescriptorTime release];
        [sortDescriptors release];
    }
	
	return fetchedResultsController;
}    

/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	[self updateReadCount];
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	 
		case NSFetchedResultsChangeUpdate:
			[(StoryCell *)[tableView cellForRowAtIndexPath:indexPath] setStory:anObject];
			[(StoryCell *)[tableView cellForRowAtIndexPath:indexPath] setNeedsLayout];
			break;
			
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}



#pragma mark -

@end

