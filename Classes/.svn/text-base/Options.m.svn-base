//
//  Options.m
//  Pomodoro
//
//  Created by surya gaddipati on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Options.h"

@interface Options (PrivateMethods)


@end
@implementation Options(PrivateMethods)



@end


@implementation Options

- (id) init {
    self = [super init];
    if (self != nil) {
		prefs = [[NSUserDefaults standardUserDefaults]retain];
    }
    return self;
}


-(void) dealloc{
	[super dealloc];
	[prefs release];
}



-(BOOL) optimizedViewOn{
	return   [prefs boolForKey:@"optimizedViewOn"];
}
-(void) setOptimizedViewOn:(BOOL) optimizedViewOn{
	[prefs setBool: optimizedViewOn  forKey:@"optimizedViewOn"];
	[prefs synchronize];
}


-(NSInteger) storyHoldTime{
	return   [prefs integerForKey:@"storyHoldTime"];
}
-(void) setStoryHoldTime:(NSInteger) count{
	[prefs setInteger: count forKey:@"storyHoldTime"];
	[prefs synchronize];
}



-(NSString*) twitterUserName{
	return   [prefs stringForKey:@"twitterUserName"];
}
-(void) setTwitterUserName:(NSString*) twitterUserName{
	[prefs setObject:twitterUserName forKey:@"twitterUserName"];
	[prefs synchronize];
}



+(Options*) get{
	return [[[Options alloc]init]autorelease];
	
}

@end
