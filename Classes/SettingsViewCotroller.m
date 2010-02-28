//
//  SettingsViewCotroller.m
//  FollowMyTeams
//
//  Created by surya gaddipati on 1/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewCotroller.h"


@implementation SettingsViewCotroller

static NSString* kApiKey = @"4affaa0f874459ab1fa5fe8850ccc053";

// Enter either your API secret or a callback URL (as described in documentation):
static NSString* kApiSecret = @"8c5ed6ccbadfef3003516a59cd3ddda4"; // @"<YOUR SECRET KEY>";
-(IBAction) signOutTwitter{
}
-(IBAction) signOutFacebook{
	[_session logout];
}

-(IBAction) signInFacebook{
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:_session] autorelease];
		[dialog show];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[_session resume];
	if(_session.isConnected){
		
	}else{
		[facebookAccount setText:@"Not Signed In"];
		}
}	


- (void)viewDidLoad{
	
	_session = [[FBSession sessionForApplication:kApiKey secret:kApiSecret delegate:self] retain];
	
	
}

		- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
				}


- (void)request:(FBRequest*)request didLoad:(id)result {
	NSArray* users = result;
	NSDictionary* user = [users objectAtIndex:0];
	NSString* name = [user objectForKey:@"name"];
	[facebookAccount setText:name];
}


/**
 * Called when a user has successfully logged in and begun a session.
 */
- (void)session:(FBSession*)session didLogin:(FBUID)uid{
	
	NSString* fql = [NSString stringWithFormat:
					 @"select name from user where uid == %lld", uid];
	
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
	
}


- (void)sessionDidLogout:(FBSession*)session{
	[facebookAccount setText:@"Not Signed In"];
		
}
		
		
- (void)dealloc {
	[facebookAccount dealloc];
    [super dealloc];
}


@end
