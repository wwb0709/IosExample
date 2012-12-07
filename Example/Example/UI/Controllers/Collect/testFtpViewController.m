//
//  testFtpViewController.m
//  Example
//
//  Created by wangwb on 12-12-5.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import "testFtpViewController.h"

@interface testFtpViewController ()

@end

@implementation testFtpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    isCamera = FALSE;
    targetURL = [[NSURL alloc] init];
    
   
//    NSURL *url = [NSURL URLWithString:@"http://www.rrsc.cn/png/Ico/201209172227.png"];
//    
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//    self.chosedImage.image = image; // 在主线程中更新imageview
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:@"http://www.rrsc.cn/png/Ico/201209172227.png"];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];

        
        dispatch_async(dispatch_get_main_queue (), ^{

            self.chosedImage.image = image; // 在主线程中更新imageview
            self.chosedImage.alpha = 1;
            [UIView animateWithDuration:1.3 animations:^{
                CGRect frame =   [self.chosedImage frame];
                
                frame.origin.x -= 150;
                [self.chosedImage setFrame:frame];
                self.chosedImage.alpha = 0;

                
            } completion:^(BOOL finished){
                [UIView animateWithDuration:1.3 animations:^{
                    CGRect frame =   [self.chosedImage frame];
                    
                    frame.origin.x += 150;
                    [self.chosedImage setFrame:frame];
                    self.chosedImage.alpha = 1;
                    
                    
                } completion:^(BOOL finished){
                    
                }];

            }];

            
        });
        
    });
    
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_chosedImage release];
    [_sendStatu release];
    [_segmentVideoQuality release];
    [targetURL release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setChosedImage:nil];
    [self setSendStatu:nil];
    [self setSegmentVideoQuality:nil];
    [super viewDidUnload];
}




#pragma mark -
#pragma mark ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
    
    NSLog(@"info = %@",info);
    
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	
	if([mediaType isEqualToString:@"public.movie"])			//被选中的是视频
	{
		NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
		targetURL = url;		//视频的储存路径
		
		if (isCamera)
		{
			//保存视频到相册
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			[library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:nil];
			[library release];
		}
		
		//获取视频的某一帧作为预览
        [self getPreViewImg:url];
	}
	else if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
		
        NSString *fileName = [[NSString alloc] init];
        
        if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
            fileName = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
            //ReferenceURL的类型为NSURL 无法直接使用  必须用absoluteString 转换，照相机返回的没有UIImagePickerControllerReferenceURL，会报错
            fileName = [self getFileName:fileName];
        }
        else
        {
            fileName = [self timeStampAsString];
        }
		
        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        
        [myDefault setValue:fileName forKey:@"fileName"];
		if (isCamera) //判定，避免重复保存
		{
			//保存到相册
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			[library writeImageToSavedPhotosAlbum:[image CGImage]
									  orientation:(ALAssetOrientation)[image imageOrientation]
								  completionBlock:nil];
			[library release];
		}
		
		[self performSelector:@selector(saveImg:) withObject:image afterDelay:0.0];
		[image release];
	}
	else
	{
		NSLog(@"Error media type");
		return;
	}
	isCamera = FALSE;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@"Cancle it");
	isCamera = FALSE;
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma -
#pragma ftpDelegate
// Successes
- (void) receivedListing: (NSDictionary *) listing;
{
     isSending = NO;
    NSLog(@"listing");
    _sendStatu.text = @"listing";
}
- (void) downloadFinished
{
     isSending = NO;
    NSLog(@"finish");
    _sendStatu.text = @"download";
}
- (void) dataUploadFinished: (NSNumber *) bytes
{
     isSending = NO;
    NSLog(@"data upload finish,%@",bytes);
    NSString* str = [NSString stringWithFormat:@"UploadFinished:%@",bytes];
    _sendStatu.text = str;
    
}
- (void) progressAtPercent: (NSNumber *) aPercent
{
    NSLog(@"percent");
    NSString* str = [NSString stringWithFormat:@"progressAtPercent:%@",aPercent];
    _sendStatu.text = str;
}


// Failures
- (void) listingFailed
{
     isSending = NO;
    _sendStatu.text = @"listingFailed";
    
}
- (void) dataDownloadFailed: (NSString *) reason
{
     isSending = NO;
    NSString* str = [NSString stringWithFormat:@"dataDownloadFailed:%@",reason];
    _sendStatu.text = str;
}
- (void) dataUploadFailed: (NSString *) reason
{
    isSending = NO;
    NSString* str = [NSString stringWithFormat:@"dataUploadFailed:%@",reason];
    _sendStatu.text = str;
}
- (void) credentialsMissing
{
     isSending = NO;
     _sendStatu.text = @"credentialsMissing";
}


#pragma mark -
#pragma mark userFunc
-(void)sendFileByPath:(NSURL *)filePath
{
	NSLog(@"sendFileByPath Func");
    [self ftpSetting];
	[FTPHelper upload:filePath];
}

-(void)sendFileByData:(NSData *)fileData fileName:(NSString *)name
{
	[self ftpSetting];
	[FTPHelper uploadByData:fileData fileName:name];
}
-(void)ftpSetting
{
    [FTPHelper sharedInstance].delegate = self;
	
	//最好改用Preference Setting
	[FTPHelper sharedInstance].uname = @"wwb";
	[FTPHelper sharedInstance].pword = @"wwb0916";
	[FTPHelper sharedInstance].urlString = @"ftp://192.168.1.168:21";
}




- (IBAction)chosePic:(id)sender {
    if (isSending) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
        //混合类型 photo + movie
		picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

- (IBAction)sendPic:(id)sender {
    if (targetURL == NULL)
    {
        if (_chosedImage.image == NULL) {
            NSLog(@"nil");
            return;
        }
        if (isSending) {
            return;
        }
        
		NSData *dataImg = UIImagePNGRepresentation(_chosedImage.image);
        
        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        
        NSString *imageName = [[NSString alloc] initWithString:(NSString *)[myDefault objectForKey:@"fileName"]];
        NSLog(@"imageName = %@",imageName);
        isSending = YES;
         _sendStatu.text = @"uploading..";
		[self sendFileByData:dataImg fileName:imageName];
	}
	else {
        isSending = YES;
        _sendStatu.text = @"uploading..";
		[self sendFileByPath:targetURL];
	}
}

- (IBAction)startCamera:(id)sender {
    if (isSending) {
        return;
    }
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
	camera.delegate = self;
	camera.allowsEditing = YES;
	isCamera = TRUE;
	
	//检查摄像头是否支持摄像机模式
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		camera.sourceType = UIImagePickerControllerSourceTypeCamera;
		camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	}
	else
	{
		NSLog(@"Camera not exist");
		return;
	}
	
    //仅对视频拍摄有效
	switch (_segmentVideoQuality.selectedSegmentIndex) {
		case 0:
			camera.videoQuality = UIImagePickerControllerQualityTypeHigh;
			break;
		case 1:
			camera.videoQuality = UIImagePickerControllerQualityType640x480;
			break;
		case 2:
			camera.videoQuality = UIImagePickerControllerQualityTypeMedium;
			break;
		case 3:
			camera.videoQuality = UIImagePickerControllerQualityTypeLow;
			break;
		default:
			camera.videoQuality = UIImagePickerControllerQualityTypeMedium;
			break;
	}
	
	[self presentModalViewController:camera animated:YES];
	[camera release];
    
}

-(void)getPreViewImg:(NSURL *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    [self performSelector:@selector(saveImg:) withObject:img afterDelay:0.1];
    [img release];
}

-(NSString *)getFileName:(NSString *)fileName
{
	NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
	NSString *suffix = [temp lastObject];
	
	temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];
	
	NSString *name = [temp lastObject];
	
	name = [name stringByAppendingFormat:@".%@",suffix];
	return name;
}

-(void)saveImg:(UIImage *) image
{
	NSLog(@"Review Image");
	_chosedImage.image = image;
}

-(NSString *)timeStampAsString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd-HHmmss"];
    NSString *locationString = [df stringFromDate:nowDate];
    return [locationString stringByAppendingFormat:@".png"];
}

@end
