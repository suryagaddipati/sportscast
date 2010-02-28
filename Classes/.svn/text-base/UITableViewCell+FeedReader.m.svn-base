//
//  UITableViewCell+FeedReader.m
//  FollowMyTeams
//
//  Created by surya gaddipati on 9/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UITableViewCell+FeedReader.h"

#import "Three20/Three20.h"
#import "NSDateHelper.h"
#define TITLELABEL_TAG 2

#define SUMMARYLABEL_TAG 3
#define LOGO_IMAGE_TAG 4
#define READ_DOT 5

#define DATE_LABEL_TAG 6
#define SOURCE_LABEL_TAG 7

@implementation UITableViewCell(FeedReader)
-(void)formatForNewsItem{
	UILabel  *titleLabel,*dateLabel,*sourceLabel;
	
	TTStyledTextLabel* summaryLabel;
	
	
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
	
	
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 18.0, 230.0, 32.0)] ;
	titleLabel.tag = TITLELABEL_TAG;
	titleLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:14.0];
	titleLabel.textAlignment = UITextAlignmentLeft;
	titleLabel.numberOfLines =0;
	titleLabel.lineBreakMode=UILineBreakModeTailTruncation;
	titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[self.contentView addSubview:titleLabel];
	[titleLabel release];
	
	sourceLabel  = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 3.0, 150.0, 14.0)] ;
	sourceLabel.tag = SOURCE_LABEL_TAG;
	sourceLabel.font = [UIFont systemFontOfSize:12];
	sourceLabel.textAlignment = UITextAlignmentLeft;
		[self.contentView addSubview:sourceLabel];
	[sourceLabel setTextColor:[UIColor greenColor]];
	[sourceLabel release];
	
	
	dateLabel  = [[UILabel alloc] initWithFrame:CGRectMake(205.0, 3.0, 95.0, 14.0)] ;
	dateLabel.tag = DATE_LABEL_TAG;
	dateLabel.font = [UIFont systemFontOfSize:12];
	dateLabel.textAlignment = UITextAlignmentRight;
	[self.contentView addSubview:dateLabel];
	[dateLabel setTextColor:[UIColor blueColor]];
	[dateLabel release];
	
	
	
	summaryLabel = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(55, 51.0, 250 , 32.0)] autorelease];
	summaryLabel.tag = SUMMARYLABEL_TAG;
	summaryLabel.font = [UIFont systemFontOfSize:12];
	summaryLabel.textColor = [UIColor grayColor];
	[self.contentView addSubview:summaryLabel];
	
	
		UIImageView* logoImage ;
  	logoImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 3.0, 50.0, 53.0)]autorelease] ;
    logoImage.tag	= LOGO_IMAGE_TAG;
	[self.contentView addSubview:logoImage];
	
	UIImageView* read ;
	read = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 54.0, 50.0, 26.0)]autorelease] ;
	read.image = [UIImage imageNamed:@"bluedot1.png"];
	read.tag = READ_DOT;
	[self.contentView addSubview:read];
	
}


-(void)markAsRead{
	//UILabel* titleLabel = (UILabel*)	[self.contentView  viewWithTag:TITLELABEL_TAG];
//	[titleLabel setTextColor:[UIColor lightGrayColor]];
 
	UIView* readImage = [self.contentView  viewWithTag:READ_DOT];
	[readImage removeFromSuperview];
}

-(void) displayStory:(Story*)story{
	
	UILabel  *titleLabel,*dateLabel,*sourceLabel;
	
	TTStyledTextLabel* summaryLabel;
	titleLabel = (UILabel *)[self.contentView viewWithTag:TITLELABEL_TAG];
	dateLabel = (UILabel *)[self.contentView viewWithTag:DATE_LABEL_TAG];
	sourceLabel = (UILabel *)[self.contentView viewWithTag:SOURCE_LABEL_TAG];
	summaryLabel = (TTStyledTextLabel *)[self.contentView viewWithTag:SUMMARYLABEL_TAG];	

	
	
	dateLabel.text = [story.pubDate relativeFormattedDateOnly];
	sourceLabel.text = story.source;
	titleLabel.text = story.title  ;
	if(  [ story.read boolValue]){
		[self markAsRead];
	}
	summaryLabel.text = [TTStyledText textFromXHTML: [ story getSummary] lineBreaks:FALSE URLs:FALSE];
	[summaryLabel setNeedsLayout];
	UIImageView* logoImage = (UIImageView*) [self.contentView viewWithTag:LOGO_IMAGE_TAG];
	logoImage.image = [UIImage imageNamed:[story.newSource logoImage]];
}



@end
