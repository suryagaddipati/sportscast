//
//  Story.h
//  FollowMyTeams
//
//  Created by surya gaddipati on 8/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Story :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSString * dateOnly;
@property (nonatomic, retain) NSString * id;
-(BOOL) isOld;
-(NSString*) getContent;
-(NSString*) getSummary;
@end



