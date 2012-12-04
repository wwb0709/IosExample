//
//  TestCallViewController.m
//  Example
//
//  Created by wangwb on 12-12-4.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import "TestCallViewController.h"
#import <AddressBook/AddressBook.h>

@interface TestCallViewController ()

@end

@implementation TestCallViewController

@synthesize callCenter;
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
    
    [self StartCallCenter];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 拨号历史相关
-(void) StartCallCenter
{
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler = ^(CTCall *call)
    {
        if (CTCallStateDialing == call.callState)
        {
            //            NSLog(@"CTCallStateDialing call:%@", [call description]);
            self.dialstatu.text = @"CTCallStateDialing";
            
        }
        else if (CTCallStateIncoming == call.callState)
        {
            self.dialstatu.text = @"CTCallStateIncoming";
            //            NSLog(@"CTCallStateIncoming call:%@", [call description]);
            
        }
        else if (CTCallStateConnected == call.callState)
        {
            self.dialstatu.text = @"CTCallStateConnected";
            //            NSLog(@"CTCallStateConnected call:%@", [call description]);
        }
        else if (CTCallStateDisconnected == call.callState)
        {
            self.dialstatu.text = @"CTCallStateDisconnected";
            //            NSLog(@"CTCallStateDisconnected call:%@", [call description]);
            //             [self insertCallRecord];
            
            
        }
        
    };
}

- (IBAction)dial:(id)sender {
    self.phonenum.text = self.inputPhoneNum.text;
    self.dialstatu.text = @"正在拨打...";
    [self sendObject:self.dialstatu.text];
    [self.inputPhoneNum resignFirstResponder];
    NSString * number = self.phonenum.text;
    
    [self inSertIntoAddressBookWithPhone:number];

	NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
}
-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    int w = img.size.width;
    int h = img.size.height;
    
    CGSize size =CGSizeMake(w, h); //设置上下文（画布）大小
    UIGraphicsBeginImageContext(size); //创建一个基于位图的上下文(context)，并将其设置为当前上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext(); //获取当前上下文
    CGContextTranslateCTM(contextRef, 0, h);  //画布的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0);  //画布翻转
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, w, h), [img CGImage]);  //在上下文种画当前图片
    
    
    [[UIColor redColor] set];  //上下文种的文字属性
    CGContextTranslateCTM(contextRef, 0, h);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    UIFont *font = [UIFont boldSystemFontOfSize:50];
    [text1 drawInRect:CGRectMake(0, h/2, w, 80) withFont:font];
    
//    //设置矩形填充颜色：红色
//    CGContextSetRGBFillColor(contextRef, 1.0, 0.0, 0.0, 1.0);
//    //设置画笔颜色：黑色
//    CGContextSetRGBStrokeColor(contextRef, 0, 0, 0, 1);
//    //设置画笔线条粗细
//    CGContextSetLineWidth(contextRef, 0.6);
//    
//    //扇形参数
//    double radius=40;//半径
//    int startX=50;//圆心x坐标
//    int startY=50;//圆心y坐标
//    double pieStart=0;//起始的角度
//    double pieCapacity=60;//角度增量值
//    int clockwise=0;//0=逆时针,1=顺时针
//    
//    //逆时针画扇形
//    CGContextMoveToPoint(contextRef, startX, startY);
//    CGContextAddArc(contextRef, startX, startY, radius, radians(pieStart), radians(pieStart+pieCapacity), clockwise);
//    CGContextClosePath(contextRef);
//    CGContextDrawPath(contextRef, kCGPathEOFillStroke);
    
    
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); //移除栈顶的基于当前位图的图形上下文。
    return  res;
}
-(void)inSertIntoAddressBookWithPhone:(NSString*)phone
{
    //    1、首先初始化一个ABAddressBookRef对象
    ABAddressBookRef addressBook = ABAddressBookCreate();
    //    注意，在用完的时候，一定要进行release，不然会导致内存泄露，当然这里是CFRelease
    //
    //    2、增加一个新联系人到通讯录中
    //初始化一个record
    ABRecordRef person ;
    NSNumber *recordId  = [CacheUtil cachedItemsFor:@"ABRecordID"];
    if (recordId) {
        person = ABAddressBookGetPersonWithRecordID(addressBook, [recordId intValue]);
    }
    else
        person = ABPersonCreate();
    //这是一个空的记录，或者说是没有任何信息的联系人
    //下面给这个人 添加一个名字
    NSString *firstName = @"Tr";
    ABRecordSetValue(person, kABPersonFirstNameProperty, firstName, NULL);
    NSString *lastName = @"Lee";
    ABRecordSetValue(person, kABPersonLastNameProperty, lastName, NULL);
    //给他再加一个生日
    NSDate *bdate = [NSDate date];
    ABRecordSetValue(person, kABPersonBirthdayProperty, bdate, NULL);
    //这些都是单一值属性的设置，接下来看看多值属性的设置
    NSArray *phones = [NSArray arrayWithObjects:phone,  nil];
    NSArray *labels = [NSArray arrayWithObjects:@"iphone", nil];
    //初始化一个多值对象，类似字典
    
    
    ABMutableMultiValueRef mulRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    //循环设置值
    
    for(int i = 0; i < phones.count; i++){
        
        ABMultiValueIdentifier multivalueIdentifier;
        
        ABMultiValueAddValueAndLabel(mulRef, (CFStringRef)[phones objectAtIndex:i], (CFStringRef)[labels objectAtIndex:i], &multivalueIdentifier);
        
    }
    
    ABRecordSetValue(person, kABPersonPhoneProperty, mulRef, NULL);
    
    if(mulRef)
        
        CFRelease(mulRef);
    
    
    
    CFErrorRef  error;
    bool        success=   false;

    UIImage* image =  [self addText:[UIImage imageNamed:@"iphone.png"] text:phone];
    
 
    if (image == nil)
    {
        if (!ABPersonHasImageData(person))
            success=    true;
        else
            success = ABPersonRemoveImageData(person, &error);
    }
    else
    {
        NSData *data = UIImagePNGRepresentation(image);
        success = ABPersonSetImageData(person, (CFDataRef) data, &error);
    }
    //将新的记录，添加到通讯录中
    
    ABAddressBookAddRecord(addressBook, person, NULL);
    
    //通讯录执行保存
    
    ABAddressBookSave(addressBook, NULL);
    
    
    ABRecordID	idRecord= ABRecordGetRecordID(person);

    [CacheUtil cacheItems:[NSNumber numberWithInt:idRecord]  for:@"ABRecordID"];
    //不说了，你懂的～
    
    if(addressBook)
        
        CFRelease(addressBook);

}



- (void)dealloc {
    [_phonenum release];
    [_dialstatu release];
    [_inputPhoneNum release];
    [callCenter release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPhonenum:nil];
    [self setDialstatu:nil];
    [self setInputPhoneNum:nil];
    [self setCallCenter:nil];
    [super viewDidUnload];
}
- (IBAction)getValue:(id)sender {
    UITextField *textFiled = sender;
    NSLog(@"getValue：%@",textFiled.text);
    
}
@end
