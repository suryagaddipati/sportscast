//
//
//  Created by surya gaddipati on 6/25/09.
//  Copyright 2009 . All rights reserved.
//

#import "SportSelectionController.h"
#import "TeamSelectionController.h"
#import "RootViewController.h"

@implementation SportSelectionController

- (IBAction)onSportSelection:(id)sender{
	TeamSelectionController *ctrl = [[TeamSelectionController alloc] initWithNibNameAndSport:@"TeamSelectionController" bundle:nil sport:  ((UIButton*)sender).titleLabel.text  teamSelection : selectionController	];
	[self.navigationController pushViewController:ctrl animated:YES];
	[ctrl release];	
}



- (id)initWithNibNameAndSport:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil   teamSelection :(MainTeamSelectionViewController*) contrllr {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		selectionController = contrllr;
				
	}
	return self;
}

- (BOOL) hidesBottomBarWhenPushed{
	return YES;
}

@end
