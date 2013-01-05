//
//  RootViewController.h
//  ScanTest
//
//  Created by David Kavanagh on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import "ZBarReaderViewController.h"
@interface RootViewController : UIViewController <ZXingDelegate,ZBarReaderDelegate>
{
  IBOutlet UITextView *resultsView;
  NSString *resultsToDisplay;
}
@property (nonatomic, retain) IBOutlet UITextView *resultsView;
@property (nonatomic, copy) NSString *resultsToDisplay;

@property (retain, nonatomic) IBOutlet UISegmentedControl *scanType;
- (IBAction)scanPressed:(id)sender;
@end
