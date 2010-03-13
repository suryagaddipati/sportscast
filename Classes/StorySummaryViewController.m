//
//  StorySummaryViewController.m
//  FollowMyTeams
//
//  Created by surya gaddipati on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StorySummaryViewController.h"
#import "StoryDetailController.h"
#import "TextAlertView.h"
#define twitterAlert 67
#define AD_REFRESH_PERIOD 1.0
#import "Options.h"
#import "SFHFKeychainUtils.h"
#import "AdMobView.h"
#import "TwitterViewViewController.h"
static NSString* kApiKey = @"4affaa0f874459ab1fa5fe8850ccc053";

// Enter either your API secret or a callback URL (as described in documentation):
static NSString* kApiSecret = @"8c5ed6ccbadfef3003516a59cd3ddda4"; // @"<YOUR SECRET KEY>";
static NSString* kGetSessionProxy = nil; // @"<YOUR SESSION CALLBACK)>";



@interface StorySummaryViewController()

-(void) sendEmail;
-(void) tweet;
-(void) handleShare :(NSInteger)buttonIndex;
-(void) postToFaceBook;
-(void) sendTweet:(NSString*)username password:(NSString*)password;
@end



@implementation StorySummaryViewController
@synthesize webView,story,m_activity;



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil story:(Story*) currentStory{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	    self.story = currentStory;
		if (kGetSessionProxy) {
			_session = [[FBSession sessionForApplication:kApiKey getSessionProxy:kGetSessionProxy
												delegate:self] retain];
		} else {
			_session = [[FBSession sessionForApplication:kApiKey secret:kApiSecret delegate:self] retain];
		}
    }
    return self;
}

-(IBAction) keepReading:(id)sender{

	
		StoryDetailController *anotherViewController = [[StoryDetailController alloc] init];
    	[anotherViewController setUrl: [story getDetailUrl]];
	
	[self.navigationController pushViewController:anotherViewController animated:YES];
	[anotherViewController release];
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
			[self handleShare:buttonIndex];	 
	
	
}




-(void) handleShare :(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self sendEmail];
			break;
		//case 1:
//			[self tweet];
//			break;	 
		case 1:
			[self postToFaceBook];
			break	;
		default:
			break;
	}
}

-(void) postToFaceBook{
	[_session resume];
	if(_session.isConnected){
	}else{
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:_session] autorelease];
			[dialog show];
	}
	

}

- (IBAction) shareAction : (id) sender {
	UIActionSheet* sheet = [[[UIActionSheet alloc] initWithTitle:@"" delegate:self
											   cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil
											   otherButtonTitles:NSLocalizedString(@"Email", @""),NSLocalizedString(@"Facebook", @""), nil] autorelease];
	[sheet showInView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString* text = [NSString stringWithFormat:@"<h2>%@</h2>%@", story.title, [story getContent]];
	[webView loadHTMLString:text baseURL:nil];
/*
	if([story isTwitter]){
		NSURL * url = [NSURL URLWithString : [story getDetailUrl  ] ];
		 
		[webView loadRequest:[NSURLRequest requestWithURL : url  ]];
	}else {
		[webView loadHTMLString:text baseURL:nil];
	}
*/
	
	
	
	
	
	// Request an ad
	adMobAd = [AdMobView requestAdWithDelegate:self]; // start a new ad request
	[adMobAd retain]; // this will be released when it loads (or fails to load)
	
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) hidesBottomBarWhenPushed{
	return YES;
}

- (void)dealloc {
	[webView release];
	[story	 release];
	[_session release];
	if(passwordAlert != nil) [passwordAlert release];
	[adMobAd release];
	[refreshTimer invalidate];
	[m_activity release];
    [super dealloc];
}


-(void) tweet{
			NSError *errord;
	NSString* twitterUserName = [Options get].twitterUserName;
	NSString* twitterPassword = [SFHFKeychainUtils getPasswordForUsername:twitterUserName andServiceName:@"twitter" error:&errord];
	if(twitterUserName == nil || twitterPassword == nil){
		passwordAlert = [[TextAlertView alloc] initWithTitle:@"Twitter Username/Password" message:@"\n\n\n"
													delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
	}else{
		[self sendTweet:twitterUserName password:[SFHFKeychainUtils getPasswordForUsername:twitterUserName andServiceName:@"twitter" error:&errord]];
	}
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if( buttonIndex > 0) {
		TextAlertView* userNamePassword = ((TextAlertView*)alertView);
		
		[Options get].twitterUserName = [userNamePassword userName];
		NSError *errord;
		[SFHFKeychainUtils storeUsername:[userNamePassword userName] andPassword:[userNamePassword password] forServiceName:@"twitter" updateExisting:NO error:&errord];
		
		[self sendTweet:[userNamePassword userName] password:[userNamePassword password]];
	}
}

-(void) sendTweet:(NSString*)username password:(NSString*)password{
	
	TwitterViewViewController* tweetViewController = [[TwitterViewViewController alloc] initWithNibName:@"TwitterViewViewController" bundle:nil  ];
	
	tweetViewController.username = username;
	tweetViewController.password = password;
	[tweetViewController setInitialText: [ NSString stringWithFormat :  @"%@ %@ ", story.title,  [story.link stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]  ]];
	[self.navigationController presentModalViewController:tweetViewController animated:YES];
	//[tweetViewController release];
	
	

	
}

-(void)sendEmail 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:story.title];
	[picker setMessageBody:story.link isHTML:NO];	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[self dismissModalViewControllerAnimated:YES];
}


- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	
	NSString* fql = [NSString stringWithFormat:
					 @"select uid,name from user where uid == %lld", session.uid];
	
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
	
	
	FBFeedDialog* dialog = [[[FBFeedDialog alloc] init] autorelease];
	dialog.delegate = self; 
	dialog.templateBundleId = 119779283033; 
	dialog.templateData =  [NSString stringWithFormat:  @"{\"title\": \" %@\"}", story.title]; 
	[dialog show];
	
}

- (void)sessionDidLogout:(FBSession*)session {
	
}


- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
	
	NSLog( [NSString stringWithFormat:@"Error(%d) %@", error.code,error.localizedDescription]);
}




- (void)refreshAd:(NSTimer *)timer {
	[adMobAd requestFreshAd];
}

#pragma mark -
#pragma mark AdMobDelegate methods

- (NSString *)publisherId {
	return @"a14b845cc10172f"; // this should be prefilled; if not, get it from www.admob.com
}

- (UIColor *)adBackgroundColor {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)primaryTextColor {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColor {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (BOOL)mayAskForLocation {
	return NO; // this should be prefilled; if not, see AdMobProtocolDelegate.h for instructions
}

// To receive test ads rather than real ads...
/*
 - (BOOL)useTestAd {
 return NO;
 }
 
 - (NSString *)testAdAction {
 return @"url"; // see AdMobDelegateProtocol.h for a listing of valid values here
 }*/


// Sent when an ad request loaded an ad; this is a good opportunity to attach
// the ad view to the hierachy.
- (void)didReceiveAd:(AdMobView *)adView {
	NSLog(@"AdMob: Did receive ad");
	// get the view frame
	CGRect frame = self.view.frame;
	
	// put the ad at the bottom of the screen
	adMobAd.frame = CGRectMake(0, frame.size.height - (48+50), frame.size.width, 48);
	
	[self.view addSubview:adMobAd];
	[refreshTimer invalidate];
	refreshTimer = [NSTimer scheduledTimerWithTimeInterval:AD_REFRESH_PERIOD target:self selector:@selector(refreshAd:) userInfo:nil repeats:YES];
}

// Sent when an ad request failed to load an ad
- (void)didFailToReceiveAd:(AdMobView *)adView {
	NSLog(@"AdMob: Did fail to receive ad");
	[adMobAd release];
	adMobAd = nil;
	// we could start a new ad request here, but in the interests of the user's battery life, let's not
}



- (void)webViewDidFinishLoad:(UIWebView *)webView {    
	[m_activity stopAnimating];  
	
}

- (void)webViewDidStartLoad:(UIWebView *)webView {     
	[m_activity startAnimating];     

}

@end
