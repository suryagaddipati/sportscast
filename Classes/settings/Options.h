//
//  Options.h
//  Pomodoro
//
//  Created by surya gaddipati on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Options : NSObject {
	NSUserDefaults *prefs;
}



@property BOOL optimizedViewOn;
@property NSInteger storyHoldTime;
@property (nonatomic, retain)  NSString* twitterUserName;

+(Options*) get;
@end
