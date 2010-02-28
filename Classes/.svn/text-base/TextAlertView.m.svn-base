

#import "TextAlertView.h"

@implementation TextAlertView




#define userNameTag 10
#define passwordTag 20


/*
 *	Initialize view with maximum of two buttons
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle
			  otherButtonTitles:otherButtonTitles, nil];
	if (self) 
	{
				
		UIImageView *passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"passwordfield" ofType:@"png"]]];
		passwordImage.frame = CGRectMake(11,79,262,31);
		[self addSubview:passwordImage];
		UITextField *userNameField;
		UITextField *passwordField;

		
		
		userNameField = [[UITextField alloc] initWithFrame:CGRectMake(12,40,260,25)];
		userNameField.font = [UIFont systemFontOfSize:18];
		userNameField.backgroundColor = [UIColor whiteColor];
		userNameField.keyboardAppearance = UIKeyboardAppearanceAlert;
		userNameField.delegate = self;
		userNameField.tag = userNameTag;
		[userNameField becomeFirstResponder];
		[self addSubview:userNameField];
		
		
		
		passwordField = [[UITextField alloc] initWithFrame:CGRectMake(16,83,252,25)];
		passwordField.font = [UIFont systemFontOfSize:18];
		passwordField.tag = passwordTag;
		passwordField.backgroundColor = [UIColor whiteColor];
		passwordField.secureTextEntry = YES;
		passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
		passwordField.delegate = self;
		[passwordField becomeFirstResponder];
		[self addSubview:passwordField];
		
		
			
		
		
		[self setTransform:CGAffineTransformMakeTranslation(0,109)];
		[self show];
		
		[passwordField release];
		[passwordImage release];
		[userNameField release];	
		
		}
	return self;
}

/*
 *	Show alert view and make keyboard visible
 */
- (void) show
{
	[super show];
//	[[self textField] becomeFirstResponder];
}



-(NSString*) userName{
	return  ((UITextView*)[self viewWithTag:userNameTag]).text;
}

-(NSString*) password{
		return  ((UITextView*)[self viewWithTag:passwordTag]).text;;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	//if( textField.tag == userNameTag){
//		userName = textField.text;
//	}else{
//		password = textField.text;
//	}
  
}
@end
