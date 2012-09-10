//
//  DAPageControl.m
//  VANCL_iPad
//
//  Created by sihai on 11-5-12.
//  Copyright 2011 YEK & VANCL. All rights reserved.
//

#import "DAPageControl.h"



@interface DAPageControl (Private)
-(void) updateDots;
@end


@implementation DAPageControl
@synthesize imageNormal = mImageNormal;
@synthesize imageCurrent = mImageCurrent;

-(void) internalInit{
    mImageNormal=nil;
    mImageCurrent=nil;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        [self internalInit];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self!=nil){
        [self internalInit];
    }
    return self;
}


-(void)dealloc{
	[mImageNormal release];
	[mImageCurrent release];
	mImageNormal=nil;
	mImageCurrent=nil;
	[super dealloc];
}
-(void) setNumberOfPages:(NSInteger) anum{
	[super setNumberOfPages:anum];
	[self updateDots];
}
- (void) setCurrentPage:(NSInteger) currentPage
{
	[super setCurrentPage:currentPage];
	[self updateDots];
}

- (void) updateCurrentPageDisplay
{
	[super updateCurrentPageDisplay];
	[self updateDots];
}

- (void) setImageNormal:(UIImage *)image
{
	[mImageNormal autorelease];
	mImageNormal = [image retain];
	[self updateDots];
}

- (void) setImageCurrent:(UIImage *)image
{
	[mImageCurrent autorelease];
	mImageCurrent = [image retain];
	[self updateDots];
}

#pragma mark - (Private)

- (void) updateDots
{
	if(mImageCurrent && mImageNormal)
	{
		NSArray * dotViews = self.subviews;
		for (int i=0; i<dotViews.count; i++) {
			UIImageView * dot = [dotViews objectAtIndex:i];
			dot.image = (i == self.currentPage) ? mImageCurrent : mImageNormal;
			dot.frame=CGRectMake(dot.frame.origin.x, dot.frame.origin.y, dot.image.size.width, dot.image.size.height);
		}
	}
}

@end
