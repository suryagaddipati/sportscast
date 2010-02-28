//
//  UITableViewCell+FeedReader.h
//  FollowMyTeams
//
//  Created by surya gaddipati on 9/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Story.h"

@interface UITableViewCell(FeedReader)
-(void)formatForNewsItem;
-(void) displayStory:(Story*)story;
-(void)markAsRead;
@end
