//
//  TTSearchlightLabel+FeedReader.m
//  FollowMyTeams
//
//  Created by surya gaddipati on 9/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTSearchlightLabel+FeedReader.h"


@implementation TTSearchlightLabel(FeedReader)

-(void) initForFeeds{
	self.opaque = NO;
	self.alpha = 0.9;
	self.backgroundColor = [UIColor blackColor];
	self.font = [UIFont systemFontOfSize:15];
	self.textAlignment = UITextAlignmentCenter;
	self.contentMode = UIViewContentModeCenter;	
}

-(void) startedReading{
	self.text = @"Updating News...";
	[[UIApplication sharedApplication].keyWindow addSubview:self];
	[self startAnimating];	
}

-(void) failedUpdate{
	self.text = @"Update Failed...";
	[self stopAnimating];
}

-(void) doneReading{
	[self  removeFromSuperview];
	[self stopAnimating];
}


static TTSearchlightLabel *gInstance = NULL;

+ (TTSearchlightLabel *)instance
{
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[TTSearchlightLabel alloc] initWithFrame:CGRectMake(0,410,320,23)];
		[ gInstance initForFeeds];
			}
    return(gInstance);
}



@end
