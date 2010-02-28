

#import <UIKit/UIKit.h>
#import "NewsSource.h"
#import <CoreData/CoreData.h>

@interface MainTeamSelectionViewController : UITableViewController<NSFetchedResultsControllerDelegate> {
	

	NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;


@end
