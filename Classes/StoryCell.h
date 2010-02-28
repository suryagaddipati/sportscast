
#import "Story.h"
@class StoryView;

@interface StoryCell : UITableViewCell {
	StoryView *storyView;
}

@property (nonatomic, retain) StoryView *storyView;
- (void)setStory:(Story *)newStory;

-(void) refresh;

@end
