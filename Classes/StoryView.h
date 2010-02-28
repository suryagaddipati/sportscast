
#import "Story.h"
@class StoryCell;
@interface StoryView : UIView {
	Story* story;

}

@property (nonatomic, retain)Story* story;
-(void) refresh;


@end
