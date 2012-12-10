//
//  Cell.m
//  ShuDu
//
//  Created by wangwb on 12-12-10.
//
//

#import "Cell.h"

@implementation Cell
@synthesize isBlank;
@synthesize x;
@synthesize y;
@synthesize value;
@synthesize userValue;
@synthesize noteList;
- (id)init {
	if( (self = [super init]) ){
        isBlank = YES;
        x = 0;
        y = 0;
        value = 0;
        userValue = 0;
        noteList = nil;
        noteList = [[NSMutableArray alloc]initWithCapacity:9];
    }
    return self;
}

-(void)dealloc
{
    [noteList release];
    [super dealloc];
}
@end
