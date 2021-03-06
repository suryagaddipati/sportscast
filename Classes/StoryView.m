
#import "StoryView.h"
#import "Three20/Three20.h"
#import "NSDateHelper.h"
#import "UIColorHelper.h"
@implementation StoryView
@synthesize story;

#define SUMMARYLABEL_TAG 3
- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		
		
		TTStyledTextLabel* summaryLabel;	
		
		summaryLabel = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(55, 55.0, 250 , 32.0)] autorelease];
		summaryLabel.tag = SUMMARYLABEL_TAG;
		summaryLabel.font = [UIFont systemFontOfSize:12];
		summaryLabel.textColor = [UIColor grayColor];
		[self addSubview:summaryLabel];
		[self setBackColor];
		
	//	self.image = [UIImage imageNamed:@"middleRow.png"];
		
	}
	return self;
}

-(void) setBackColor{
	
	//NSLog(@"Story %@ is ::::: %d " , story.summary,[story.read boolValue]);
	
	
   if(![self.story.read boolValue] && self.story != nil)
		self.backgroundColor =UIColorFromRGB(0x72E5FF);
	else
		self.backgroundColor = [UIColor whiteColor];	
}

- (void)setStory:(Story *)newStory {
	
	if (story != newStory) {
		[story release];
		story = [newStory retain];
		TTStyledTextLabel* summaryLabel =(TTStyledTextLabel *)[self viewWithTag:SUMMARYLABEL_TAG];	
		summaryLabel.text = [TTStyledText textFromXHTML: [ story getSummary] lineBreaks:FALSE URLs:FALSE];
		//summaryLabel.opaque = NO;
		summaryLabel.backgroundColor = [UIColor clearColor];
		[summaryLabel setNeedsDisplay];
		
	}
	[self setBackColor];
	[self setNeedsDisplay];
	[self setNeedsLayout];
}


- (void)drawRect:(CGRect)rect {
	
#define TOP_MARGIN 3
#define LEFT_MARGIN 3
#define RIGHT_MARGIN 5
	
	
#define LOGO_WIDTH 50
#define LOGO_Y 50	
	
#define SOURCE_WIDTH 150
#define SOURCE_FONT_SIZE 12	
	
#define DATE_WIDTH 95
#define DATE_FONT_SIZE 12		
	
#define TITLE_FONT_SIZE 14
#define SPACING_WIDTH 2	
	
	[self setBackColor];
		
	
	CGRect contentRect = self.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern.
	
	CGFloat boundsX = contentRect.origin.x;
	CGPoint point;
	CGFloat actualFontSize;
 //  [[UIImage imageNamed:@"middleRow.png"] drawAtPoint:CGPointMake(0, 0)];
	
	point = CGPointMake(LEFT_MARGIN+2, TOP_MARGIN);
	[[UIImage imageNamed:[story.newSource logoImage]] drawAtPoint:point];
	
	
	point = CGPointMake(boundsX + LEFT_MARGIN+LOGO_WIDTH , TOP_MARGIN);
	[story.source drawAtPoint:point forWidth:SOURCE_WIDTH withFont:[UIFont systemFontOfSize:SOURCE_FONT_SIZE] minFontSize:SOURCE_FONT_SIZE actualFontSize:&actualFontSize lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
	
	[ [UIColor blueColor]set];
	point = CGPointMake(boundsX + LEFT_MARGIN+LOGO_WIDTH+SOURCE_WIDTH + 15 , TOP_MARGIN);
	[[story.pubDate relativeFormattedDateOnly] drawAtPoint:point forWidth:DATE_WIDTH withFont:[UIFont systemFontOfSize:DATE_FONT_SIZE] minFontSize:DATE_FONT_SIZE actualFontSize:&actualFontSize lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
	
	
	
	[ [UIColor blackColor]set];

	[story.title drawInRect:CGRectMake(boundsX + LEFT_MARGIN+LOGO_WIDTH+SPACING_WIDTH, TOP_MARGIN+SOURCE_FONT_SIZE+SPACING_WIDTH, contentRect.size.width-(LEFT_MARGIN+RIGHT_MARGIN+LOGO_WIDTH), 32.0) withFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE] lineBreakMode:UILineBreakModeTailTruncation];
	
		
}


-(void) refresh{
	[self setBackColor];
	[self setNeedsDisplay];
	
}


- (void)dealloc {
	
    [super dealloc];
}


@end
