

#import "GoogleReaderLogin.h"


@implementation GoogleReaderLogin

- (id) init:(id<GoogleReaderLoginDelegate>) rutControler {
    self = [super init];
    if (self != nil) {
		delegate=rutControler;
		NSString* content = @"Email=sportscoop%40gmail.com&Passwd=nutclusters&service=reader";
		
		NSURL* url = [NSURL URLWithString:@"https://www.google.com/accounts/ClientLogin"];
		NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc]
										   initWithURL:url];
		[urlRequest setHTTPMethod:@"POST"];
		[urlRequest setHTTPBody:[content dataUsingEncoding:
								 NSASCIIStringEncoding]];
		
		NSURLConnection *connectionResponse = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self]autorelease];
		if (!connectionResponse) {
			[delegate failed];
		}
		[urlRequest release];
		
    }
    return self;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	NSString* response =	[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	//NSLog(@"REsponse %@" , response);
	NSArray*tokens = [ response componentsSeparatedByString:@"\n"];
	[delegate success:[ [ ((NSString*) [tokens objectAtIndex:0]) componentsSeparatedByString:@"="] objectAtIndex:1]];
	[response release];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	
	[delegate failed];
	
}


@end
