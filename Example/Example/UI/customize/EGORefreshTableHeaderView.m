//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"

#import "DAUtility.h"
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
//#define TEXT_COLOR	 [UIColor colorWithRed:78.0/255.0 green:124.0/255.0 blue:200.0/255.0 alpha:1.0]
//#define BORDER_COLOR [UIColor colorWithRed:78.0/255.0 green:124.0/255.0 blue:200.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation EGORefreshTableHeaderView

@synthesize state=_state;
@synthesize bSound;  //是否发音

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_refresh_header.png"]];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];

		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"]) 
		{
			_lastUpdatedLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
		}
		else {
			[self setCurrentDate];
		}
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:14.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [[CALayer alloc] init];
		layer.frame = CGRectMake(24.0f, frame.size.height - 58.0f, 18.0f, 47.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		[layer release];
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		[self setState:EGOOPullRefreshNormal];
		
    }
    return self;
}

- (void)setCurrentDate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setAMSymbol:NSLocalizedString(@"上午",nil)];
	[formatter setPMSymbol:NSLocalizedString(@"下午",nil)];
	//[formatter setDateFormat:@"yyyy年MM月dd日 a hh:mm"];
    
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd%@ a hh:mm",NSLocalizedString(@"年",nil),NSLocalizedString(@"月",nil),NSLocalizedString(@"日",nil)]];
    
	_lastUpdatedLabel.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"最后更新",nil),[formatter stringFromDate:[NSDate date]]];
	[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[formatter release];
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) 
    {
		case EGOOPullRefreshPulling:
			//_statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
            if (bSound) 
            {
                [DAUtility playSoundPsstDown];
            }
            
			_statusLabel.text = NSLocalizedString(@"松开即可刷新", nil);
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {

				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
            
			if (bSound) 
            {
                [DAUtility playSoundForPsstUp];
                self.bSound = NO;
            }
			
			//_statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
			_statusLabel.text = NSLocalizedString(@"下拉可以刷新", nil);
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshLoading:
			
			//_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
            if (bSound) 
            {
                [DAUtility playSoundForUp];
            }
			_statusLabel.text = NSLocalizedString(@"正在刷新...",nil);
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)dealloc {
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
