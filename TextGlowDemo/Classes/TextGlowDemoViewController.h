//
//  TextGlowDemoViewController.h
//  TextGlowDemo
//
//  Created by Andrew on 28/04/2010.
//  Red Robot Studios 2010.
//

#import "RRSGlowLabel.h"


@interface TextGlowDemoViewController : UIViewController {
    RRSGlowLabel *label;
    UISlider *glowSlider;
}

@property (nonatomic, retain) IBOutlet RRSGlowLabel *label;
@property (nonatomic, retain) IBOutlet UISlider *glowSlider;

- (IBAction)adjustGlowAmount:(id)sender;

- (CGContextRef) MyCreateBitmapContext: (int) pixelsWide :
(int) pixelsHigh;
- (UIImage*) createDialogBox: (CGContextRef) myContext : (float) ox : (float) oy :(float) rw : (float) rh : (float) r:  (int) Orientation;

@end

