

#import <UIKit/UIKit.h>


@interface TextAlertView : UIAlertView <UITextFieldDelegate> {
	
}



- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

-(NSString*) userName;
-(NSString*) password;

@end

