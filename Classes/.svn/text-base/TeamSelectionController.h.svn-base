//
//  SelectionViewController.h
//  FutballNews
//
//  Created by surya gaddipati on 6/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTeamSelectionViewController.h"
#import <CoreData/CoreData.h>
@class SportSelectionController;



@interface TeamSelectionController : UITableViewController<NSFetchedResultsControllerDelegate> {

	NSString* sportName;

	
	MainTeamSelectionViewController* selectionController;
		NSFetchedResultsController *fetchedResultsController;
	
}
- (id)initWithNibNameAndSport:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil sport:(NSString*) withSportName teamSelection :(MainTeamSelectionViewController*) contrllr ;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
