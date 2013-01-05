// -*- Mode: ObjC; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
/*
 * Copyright 2010-2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "RootViewController.h"


#ifndef ZXQR
#define ZXQR 1
#endif

#if ZXQR
#import "QRCodeReader.h"
#endif

#ifndef ZXAZ
#define ZXAZ 0
#endif

#if ZXAZ
#import "AztecReader.h"
#endif


@interface RootViewController()

@end


@implementation RootViewController
@synthesize resultsView;
@synthesize resultsToDisplay;
#pragma mark -
#pragma mark View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"解码", @"解码");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [resultsView setText:resultsToDisplay];
}

- (IBAction)scanPressed:(id)sender {
	

	switch (_scanType.selectedSegmentIndex) {
        case 1:
        {
          ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
          
          NSMutableSet *readers = [[NSMutableSet alloc ] init];

        #if ZXQR
          QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
          [readers addObject:qrcodeReader];
          [qrcodeReader release];
        #endif
            
        #if ZXAZ
          AztecReader *aztecReader = [[AztecReader alloc] init];
          [readers addObject:aztecReader];
          [aztecReader release];
        #endif
            
          widController.readers = readers;
          [readers release];
            
        //  NSBundle *mainBundle = [NSBundle mainBundle];
        //  widController.soundToPlay =
        //    [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
            widController.view.backgroundColor = [UIColor grayColor];
          [self presentModalViewController:widController animated:YES];
          [widController release];
        }
            break;
        case 0:
        {
    
    
            ZBarReaderViewController *reader =
            [[ZBarReaderViewController alloc] init];
            reader.readerDelegate = self;
            reader.showsZBarControls = NO;
            reader.supportedOrientationsMask = ZBarOrientationMaskAll;
            
            
            //非全屏
            
//            reader.wantsFullScreenLayout = NO;
            
            //隐藏底部控制按钮
            
            reader.showsZBarControls = NO;
            
            //设置自己定义的界面
            
            [self setOverlayPickerView:reader];
            
            ZBarImageScanner *scanner = reader.scanner;
            
            [scanner setSymbology: ZBAR_I25
             
                           config: ZBAR_CFG_ENABLE
             
                               to: 0];
            
            
            
            [self presentModalViewController:reader animated:YES];
            
            [reader release];
        }
        default:
            break;
    }
    
    
}


- (void)setOverlayPickerView:(ZBarReaderViewController *)reader

{
    
    //清除原有控件
    
    for (UIView *temp in [reader.view subviews]) {
        
        for (UIButton *button in [temp subviews]) {
            
            if ([button isKindOfClass:[UIButton class]]) {
                
                [button removeFromSuperview];
                
            }
            
        }
        
        for (UIToolbar *toolbar in [temp subviews]) {
            
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                
                [toolbar setHidden:YES];
                
                [toolbar removeFromSuperview];
                
            }
            
        }
        
    }
    
    //画中间的基准线
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(40, 220, 240, 1)];
    
    line.backgroundColor = [UIColor redColor];
    
    [reader.view addSubview:line];
    
    [line release];
    
    //最上部view
    
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    
    upView.alpha = 0.3;
    
    upView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:upView];
    
    //用于说明的label
    
    UILabel * labIntroudction= [[UILabel alloc] init];
    
    labIntroudction.backgroundColor = [UIColor clearColor];
    
    labIntroudction.frame=CGRectMake(15, 20, 290, 50);
    
    labIntroudction.numberOfLines=2;
    
    labIntroudction.textColor=[UIColor whiteColor];
    
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    
    [upView addSubview:labIntroudction];
    
    [labIntroudction release];
    
    [upView release];
    
    //左侧的view
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 20, 280)];
    
    leftView.alpha = 0.3;
    
    leftView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:leftView];
    
    [leftView release];
    
    //右侧的view
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(300, 80, 20, 280)];
    
    rightView.alpha = 0.3;
    
    rightView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:rightView];
    
    [rightView release];
    
    //底部view
    
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 120)];
    
    downView.alpha = 0.3;
    
    downView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:downView];
    
    [downView release];
    
    //用于取消操作的button
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    cancelButton.alpha = 0.4;
    
    [cancelButton setFrame:CGRectMake(20, 390, 280, 40)];
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    
    [reader.view addSubview:cancelButton];
    
}

//取消button方法

- (void)dismissOverlayView:(id)sender{ 
    
    [self dismissModalViewControllerAnimated: YES];
    
}
#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
  self.resultsToDisplay = result;
  if (self.isViewLoaded) {
    [resultsView setText:resultsToDisplay];
    [resultsView setNeedsDisplay];
  }
  [self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setScanType:nil];
  self.resultsView = nil;
}

- (void)dealloc {
  [resultsView release];
  [resultsToDisplay release];
    [_scanType release];
  [super dealloc];
}


//ZBarReaderDelegate
- (void)  imagePickerController: (UIImagePickerController*) picker
  didFinishPickingMediaWithInfo: (NSDictionary*) info
{

    id <NSFastEnumeration> syms =
    [info objectForKey: ZBarReaderControllerResults];
    for(ZBarSymbol *sym in syms) {
    
         [resultsView setText:sym.data];
        break;
    }
     [self dismissModalViewControllerAnimated:YES];
}

@end

