//
//  NewsSource.h
//  FollowMyTeams
//
//  Created by surya gaddipati on 9/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
@class ParsedStory;
@class Story;

@interface NewsSource :  NSManagedObject  
{
	NSString* continuation;
}
@property (nonatomic, retain) NSString* continuation;

@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* stories;
-(NSString*)logoImage;
-(int) unReadCount;
-(void) clearStories;
-(BOOL) feedEntriesContains :(ParsedStory*) parsedStory;
-(BOOL) addFeedEntries :(NSArray*) feeds;
@end


@interface NewsSource (CoreDataGeneratedAccessors)
- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet *)value;
- (void)removeStories:(NSSet *)value;

@end

