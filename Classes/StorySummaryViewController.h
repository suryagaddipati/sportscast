//
//  StorySummaryViewController.h
//  FollowMyTeams
//
//  Created by surya gaddipati on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import <MessageUI/MessageUI.h>
#import "TextAlertView.h"
#import "FBConnect/FBConnect.h"
#import "AdMobDelegateProtocol.h"

@class AdMobView; //UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate, FBDialogDelegate, FBSessionDelegate, FBRequestDelegate,AdMobDelegate> 

@interface StorySummaryViewController : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate,AdMobDelegate,FBSessionDelegate,FBRequestDelegate,FBDialogDelegate,UIWebViewDelegate> {
	UIWebView *webView;
	Story* story;
	TextAlertView *passwordAlert;
	  FBSession* _session;
	
	IBOutlet UIActivityIndicatorView *m_activity; 
	
	AdMobView *adMobAd;
	NSTimer *refreshTimer;

}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *m_activity;
- (IBAction) shareAction : (id) sender;
-(IBAction) keepReading:(id)sender;
@property (nonatomic, retain)  Story*  story;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil story:(Story*) story;
@end
