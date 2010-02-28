//
//  TwitterViewViewController.h
//  TwitterView
//
//  Created by surya gaddipati on 9/26/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterViewViewController : UIViewController<UITextViewDelegate> {
	UILabel* wordCountLabel;
	UITextView* tweetTextView;
	NSString* initialTweet;
	NSString* username;
	NSString* password;
	
}
@property (nonatomic, retain) IBOutlet UILabel* wordCountLabel;
@property (nonatomic, retain) IBOutlet UITextView* tweetTextView;
@property (nonatomic, retain) NSString* initialTweet;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
- (IBAction)onSend:(id)sender;
- (IBAction)onCancel:(id)sender;


- (void)setInitialText:(NSString*)tweetMessage;
@end

