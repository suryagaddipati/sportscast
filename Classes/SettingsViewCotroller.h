//
//  SettingsViewCotroller.h
//  FollowMyTeams
//
//  Created by surya gaddipati on 1/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBConnect/FBConnect.h"
@interface SettingsViewCotroller : UIViewController<FBRequestDelegate,FBSessionDelegate> {
//	 IBOutlet) UILabel* twitterAccount;
	IBOutlet UILabel* facebookAccount;
    
	 FBSession* _session;
}

-(IBAction) signOutTwitter;

-(IBAction) signOutFacebook;
-(IBAction) signInFacebook;

@end
