
#import <Foundation/Foundation.h>

@protocol GoogleReaderLoginDelegate<NSObject>
-(void) failed;
-(void) success:(NSString*) sid;
@end

@interface GoogleReaderLogin : NSObject {
	id<GoogleReaderLoginDelegate> delegate ;
}
- (id) init:(id<GoogleReaderLoginDelegate>) rutControler;
@end

