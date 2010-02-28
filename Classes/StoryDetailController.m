//
//  StoryDetailController.m
//  FutballNews
//
//  Created by surya gaddipati on 6/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StoryDetailController.h"


@implementation StoryDetailController
@synthesize url;
- (void)viewDidLoad {
	[self setNavigationBarStyle : UIBarStyleBlack];
	[self openURL:[NSURL URLWithString:url]];
	UIButton* back = [ UIButton buttonWithType:  UIButtonTypeRoundedRect];
	[back setTitle:@"ssafd"  forState:UIControlStateNormal];
	[self.headerView addSubview:back];
	 
	 }
- (BOOL) hidesBottomBarWhenPushed{
	return YES;
}
@end
