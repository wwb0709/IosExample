//
//  This class was created by Nonnus, multi select by Colin
//  who graciously decided to share it with the CocoaHTTPServer community.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"


@interface MyHTTPConnection : HTTPConnection
{
	int dataStartIndex;
	NSMutableArray* multipartData;
	NSData *mykey;
	NSString *currentRoot;
	int filecount;
	BOOL redflag;  // separator was truncated at end of chunk.
}

@property(nonatomic, retain) NSString *currentRoot;
- (BOOL)isBrowseable:(NSString *)path;
- (NSString *)createBrowseableIndex:(NSString *)path;

@end
