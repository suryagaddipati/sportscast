//
//  MainTeamSelectionViewController.m
//  FutballNews
//
//  Created by surya gaddipati on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainTeamSelectionViewController.h"
#import "FollowMyTeamsAppDelegate.h"
#import "SportSelectionController.h"
#import "TeamSelectionController.h"
#import "RootViewController.h"
#define USE_CUSTOM_DRAWING 1

@implementation MainTeamSelectionViewController

@synthesize fetchedResultsController;

#pragma mark -
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
    
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	    NewsSource* currentTeam = (NewsSource *)[fetchedResultsController objectAtIndexPath:indexPath];
	return cell;
}





- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 120 ;
}



-(IBAction) onAddTeam:(id)sender{
	SportSelectionController* sportSelectController  = [[SportSelectionController alloc] initWithNibNameAndSport:@"SportSelectionViewController" bundle:nil teamSelection:self ] ;
	[self.navigationController pushViewController:sportSelectController animated:NO];
   [sportSelectController release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}

	[self.tableView reloadData];
}



- (void)viewDidLoad{
	[super viewDidLoad];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	UIBarButtonItem* button =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddTeam:)];
	self.navigationItem.rightBarButtonItem = button;
	[button release];
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}

}



- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
		FollowMyTeamsAppDelegate* delegate = [UIApplication sharedApplication].delegate;
		[delegate.managedObjectContext save:nil];
    }
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NewsSource* selectedTeam = (NewsSource *)[fetchedResultsController objectAtIndexPath:indexPath];
		selectedTeam.selected = [NSNumber numberWithBool:NO];
	    [selectedTeam clearStories];
		FollowMyTeamsAppDelegate* delegate = [UIApplication sharedApplication].delegate;
		[delegate.managedObjectContext save:nil];
		delegate.changedSelection = YES;
		//[self setEditing:NO animated:NO];
		
    }
	
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(self.tableView.editing == YES){
		SportSelectionController* sportSelectController  = [[SportSelectionController alloc] initWithNibNameAndSport:@"SportSelectionViewController" bundle:nil teamSelection:self ] ;
		[self.navigationController pushViewController:sportSelectController animated:YES];
		[sportSelectController release];
	}
}




#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
	FollowMyTeamsAppDelegate* delegate = [UIApplication sharedApplication].delegate;
	
    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
	
        NSFetchRequest *fetchRequest  = [delegate.managedObjectModel fetchRequestTemplateForName:@"fetchSelectedSources"];

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


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
			break;
			
		case NSFetchedResultsChangeUpdate:
			//[self configureCell:(RecipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			// Reloading the section inserts a new row and ensures that titles are updated appropriately.
			[tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
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
