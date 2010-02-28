

#import "TeamSelectionController.h"
#import "Constants.h"
#import "NewsSource.h"
#define SelectionLogoWidth 40
#import "SportSelectionController.h"
#import "FollowMyTeamsAppDelegate.h"

@interface TeamSelectionController(PrivateMethods) 
-(void) addCurrentSelectionLogos;
-(IBAction) addNewTeamSelection:(id)sender;

@end



@implementation TeamSelectionController
@synthesize fetchedResultsController;

-(void) dealloc{
	[sportName release];
	[super dealloc];
}




- (id)initWithNibNameAndSport:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil sport:(NSString*) withSportName  teamSelection :(MainTeamSelectionViewController*) contrllr {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		sportName = [withSportName retain];
		selectionController = contrllr;
	}
	return self;
}





-(void) addCurrentSelectionLogos{
	UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake((320-(SelectionLogoWidth+10)), 0.0, SelectionLogoWidth, 44.0)];
	
	NSString* imageName = [NSString stringWithFormat:@"%@.gif",sportName];
	[imgView3 setImage:[UIImage imageNamed: imageName  ]];
	imgView3.tag = 99;
	[self.navigationController.navigationBar addSubview:imgView3];
	[imgView3 release];	
}





-(IBAction) addNewTeamSelection:(id)sender{
	
	int index = ((UIView*)sender).tag;
	   NSUInteger pathSource[2] = {0, index};
    NewsSource* selectedTeam = (NewsSource *)[fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathWithIndexes:pathSource length:2]];
	selectedTeam.selected = [NSNumber numberWithBool:YES];
	FollowMyTeamsAppDelegate* delegate = [UIApplication sharedApplication].delegate;
	[delegate.managedObjectContext save:nil];
	delegate.changedSelection = YES;
	
	[self.navigationController popToRootViewControllerAnimated:YES];
	
	
}
- (void)viewWillDisappear:(BOOL)animated{
	UIView* logoView =[self.navigationController.navigationBar viewWithTag:99];
	[logoView removeFromSuperview];
}

- (void)viewDidLoad {
	self.navigationItem.title = @"Select Team";
	[self addCurrentSelectionLogos];
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
}

#pragma mark Table view methods

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
      NSLog(@"%@ rows",[NSNumber numberWithInt:numberOfRows] );
    return numberOfRows;
}
#define SELECT_BUTTON_TAG 3 

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   //if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
   // }
    
	/// Set up the cell
	int teamIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	  NewsSource* currentTeam = (NewsSource *)[fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text =  currentTeam.name ;
	cell.imageView.image= [UIImage imageNamed:[currentTeam logoImage]];

   
	
	if( [currentTeam.selected boolValue] ){
		//[cell.accessoryView removeFromSuperview];
		UISegmentedControl* selectButton = (UISegmentedControl*)  [cell viewWithTag:teamIndex];
		[selectButton setEnabled:FALSE];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;	
		[cell.textLabel setTextColor:[ UIColor lightGrayColor]];
		
	}else{
		
	//	
		[cell.textLabel setTextColor:[ UIColor blackColor]];
		UISegmentedControl* codeButton =  [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Select"]] ;
		codeButton.segmentedControlStyle = UISegmentedControlStyleBar;
		codeButton.momentary = YES;
		codeButton.tintColor = [UIColor blueColor];
		
		
		codeButton.tag = teamIndex;
		
		[codeButton addTarget:self action:@selector(addNewTeamSelection:) forControlEvents:UIControlEventValueChanged];
	
		
		 codeButton.frame = CGRectMake(0.0, 0.0, 50, 20);
		cell.accessoryView = codeButton;
		[codeButton release];
		
	
	}
    return cell;
}

- (BOOL) hidesBottomBarWhenPushed{
	return YES;
}
- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 55 ;
}





#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
	FollowMyTeamsAppDelegate* delegate = [UIApplication sharedApplication].delegate;
	
    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
		
        NSFetchRequest *fetchRequest  = [delegate.managedObjectModel fetchRequestTemplateForName: [NSString stringWithFormat: @"fetch%@Teams",sportName]];
		
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsSource" inManagedObjectContext:delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
		
        NSFetchedResultsController *aFetchedResultsController = [ [NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:delegate.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	
	return fetchedResultsController;
}    





#pragma mark -


@end
