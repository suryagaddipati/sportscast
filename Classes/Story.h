//
//  Story.h
//  FollowMyTeams
//
//  Created by surya gaddipati on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class NewsSource;

@interface Story :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NewsSource * newSource;

-(NSString*) getDetailUrl;
-(BOOL) isUnread;
-(BOOL) isTwitter;

@end


