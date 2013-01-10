//
//  SHHHomeViewController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHHomeViewController.h"
#import "SHHHomeNavigationController.h"
#import "ViewController.h"
#import "SHHSearchViewController.h"
#import "MTAnimatedLabel.h"
#import "DDData.h"
#import "GTMABAddressBook.h"
//#import "ProjectApplication.h"

#import "VcardPersonEntity.h"

#import "wax.h"
#import "wax_http.h"
#import "wax_json.h"
#import "wax_filesystem.h"
#import "wax_xml.h"

#import <AddressBook/AddressBook.h>
#import "SysAddrBook.h"
#import "VcardPersonEntity.h"
#define getStr(name) ([bundle pathForResource:name ofType:@"tiff"])
@implementation SHHHomeViewController

- (id) init
{
    self = [super init];
    if (self)
    {
        self.title = @"首页--";
        self.view.backgroundColor = [UIColor grayColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg640X960"]];
       
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (0) {
    
     NSString	*vpath=[[NSBundle mainBundle] pathForResource:@"testvcard.vcf" ofType:nil];
//   [self paraseVcard:vpath];
//   [self createVcard];
     NSMutableArray * arr = [NSMutableArray array];
//    [self loadFromAddrBook:arr];
     [self paraseVcard:vpath :arr];
     [self saveToAddrBook:arr];
        
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(closeViewEventHandler:)
     name:@"closeView"
     object:nil ];
    
    tickets = 100;
    count = 0;
    isFlip = NO;
    

    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"bundle"]];
    NSString *imageName = getStr(@"bubbleMine");
    
    NSLog(@"bundle:%@--image:%@",bundle,imageName);
    
    
    
    //UIiamge <-> NSData
    NSFileManager	*fileManager=	[NSFileManager defaultManager];
    NSString		*path=[[NSBundle mainBundle] pathForResource:@"jpeg.txt" ofType:nil];
	BOOL			isExist=		[fileManager fileExistsAtPath:path];
    NSString *jpeg = nil;
    if (isExist) {
        
        NSError * error= nil;
        jpeg = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        //NSLog(@"astring:%@",str);
    }
    //base64->NSData
    NSData *temp = [[jpeg dataUsingEncoding:NSUTF8StringEncoding] base64Decoded];
    
    NSData *aData = [[NSData alloc] initWithBytes:jpeg length:jpeg.length];
   // NSData* aData = //[jpeg dataUsingEncoding: NSUTF8StringEncoding];

    
    NSData *imageData = UIImagePNGRepresentation([UIImage
                                                  imageNamed:@"bubbleMine.png"]);
    
    NSString *aString = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
    NSLog(@"==astring:%@",aString);
    
    Byte *testByte = (Byte *)[imageData bytes];
    
    for(int i=0;i<[imageData length];i++)
        
        printf("testByte = %d\n",testByte[i]);
    
    
    
    
    
    UIImage *closeButton = [[UIImage alloc] initWithData:temp];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:closeButton];
    [self.view addSubview:tempImageView];
    
    
    CGSize size = closeButton.size;
    tempImageView.frame = CGRectMake(100, 100, size.width, size.height);
    [tempImageView release];
    
    
    
    
    frontImageView = [[UIImageView alloc] initWithImage:[UIImage
                                                         imageNamed:@"bubbleMine.png"]];
    
    containerView = [[UIView alloc] initWithFrame:frontImageView.bounds];
    containerView.center = CGPointMake(200,200);
    [self flipImage:frontImageView Horizontal:NO];
    [self.view addSubview:containerView];
    [containerView addSubview:frontImageView];
    
    backImageView = [[UIImageView alloc] initWithImage:[UIImage
                                                        imageNamed:@"bubbleSomeone.png"]];
    backImageView.center = frontImageView.center;

    
    //右按钮
    UIButton *tmpTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpTabBtn setFrame:CGRectMake(0, 0, 55, 37)];
    tmpTabBtn.titleLabel.text= @"startThread";
    [tmpTabBtn addTarget:self
                  action:@selector(startThread)
        forControlEvents:UIControlEventTouchUpInside];
    tmpTabBtn.backgroundColor=[UIColor clearColor];
    [tmpTabBtn setBackgroundImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
    [tmpTabBtn setBackgroundImage:[UIImage imageNamed:@"collect_h.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem * tmpBarBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpTabBtn];
    
    self.navigationItem.rightBarButtonItem = tmpBarBtn;
    [tmpBarBtn release];
    
    
    
    //左按钮
    UIButton *tmpTabBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpTabBtn1 setFrame:CGRectMake(0, 0, 55, 37)];
    tmpTabBtn1.titleLabel.text= @"startThread";
    [tmpTabBtn1 addTarget:self
                  action:@selector(loadViewBylua)
        forControlEvents:UIControlEventTouchUpInside];
    tmpTabBtn1.backgroundColor=[UIColor clearColor];
    [tmpTabBtn1 setBackgroundImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
    [tmpTabBtn1 setBackgroundImage:[UIImage imageNamed:@"collect_h.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem * tmpBarBtn1 = [[UIBarButtonItem alloc] initWithCustomView:tmpTabBtn1];
    
    self.navigationItem.leftBarButtonItem = tmpBarBtn1;
    [tmpBarBtn1 release];
    
   
    return;
    
//    MTAnimatedLabel *animatedLabel = [[MTAnimatedLabel alloc] initWithFrame:CGRectMake(50, 50, 320, 100)];
//    //UILabel *animatedLabel = [[UILabel alloc] init];
//
//    animatedLabel.text = @"hello world";
//    animatedLabel.font =  [UIFont fontWithName:@"SnellRoundhand" size:20.0f];
//    [animatedLabel setTint:[UIColor blackColor]];
//  //  animatedLabel.frame  = CGRectMake(50, 50, 320, 100);
//    animatedLabel.textColor = [UIColor blueColor];
//   
//    [self.view addSubview:animatedLabel];
//    [animatedLabel startAnimating];
//    [animatedLabel release];
//    
    
    CGRect viewRect = CGRectMake(0.0f, 50.0f, 345.0f, 50.0f);
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.wrapped = YES;
    textLayer.truncationMode = kCATruncationNone;
    UIFont *font = [UIFont fontWithName:@"SnellRoundhand" size:20.0f];
    textLayer.string = @"Lorem Lipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.";
    textLayer.alignmentMode = kCAAlignmentLeft;
    textLayer.fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, nil);
    textLayer.font = fontRef;
    CFRelease(fontRef);
    
    textLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    textLayer.foregroundColor = [[UIColor blackColor] CGColor];
    textLayer.frame = viewRect;
    
    textLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(M_PI_2/4));

    [textLayer addSublayer:[self shadowAsInverse:textLayer.frame]];
    
    UIGraphicsBeginImageContextWithOptions(textLayer.frame.size, NO, 0);
    [textLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   
    
    
    
    //[self.view.layer addSublayer:[self shadowAsInverse:self.view.frame]];
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:textImage];
    textImageView.frame = viewRect;
    //[self.view addSubview:textImageView];
    [textImageView release];

	// Do any additional setup after loading the view.
}

//Mark: ========================本地通讯录 11大类操作 start====================================================
//***************** 1、个人基本信息操作 ******************
- (void)OperBasicInfoWithProperty : (ABPropertyID)propertyId
                         andValue : (NSString*)value
                      andOperType : (OperationType)opertype
                         inPerson : (GTMABPerson *) tmpPerson
{
    if (value) {
        if (opertype == OperationType_del) {
            [tmpPerson removeValueForProperty:propertyId];
        }
        else if(opertype == OperationType_add||opertype == OperationType_edit)
            [tmpPerson setValue:value forProperty:propertyId];
    }
    
}

//***************** 2、电话号码信息操作 ******************
- (void)OperContactNumbersWithKey : (CFStringRef)key
                         andValue : (NSString*)value
                         andIndex : (NSUInteger)index
                      andOperType : (OperationType)opertype
                         inPerson : (GTMABPerson *) tmpPerson
{
    ABMultiValueRef phones= ABRecordCopyValue([tmpPerson recordRef], kABPersonPhoneProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:phones ];
    
    if (MultiValue) {
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonPhoneProperty];
    CFRelease(MultiValue);
    CFRelease(phones);
    
}
//***************** 3、相关联系人信息操作 *****************
- (void)OperRelatedContactsWithKey : (CFStringRef)key
                          andValue : (NSString*) value
                          andIndex : (NSUInteger)index
                       andOperType : (OperationType)opertype
                          inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef RelatedNames= ABRecordCopyValue([tmpPerson recordRef], kABPersonRelatedNamesProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:RelatedNames ];
    
    if (MultiValue) {
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonRelatedNamesProperty];
    CFRelease(MultiValue);
    CFRelease(RelatedNames);
    
}
//***************** 4、住址信息操作 **********************
- (void)OperAddressesWithKey : (CFStringRef)key
                    andValue :(id) value
                    andIndex : (NSUInteger)index
                 andOperType : (OperationType)opertype
                    inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef addresses= ABRecordCopyValue([tmpPerson recordRef], kABPersonAddressProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:addresses ];
    
    if (MultiValue) {
        
        
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
        
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonAddressProperty];
    
    CFRelease(MultiValue);
    CFRelease(addresses);
    
}

//***************** 5、社交信息操作 **********************
- (void)OperNetSocialWithKey : (CFStringRef)key
                    andValue : (NSString*) value
                    andIndex : (NSUInteger)index
                 andOperType : (OperationType)opertype
                    inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef SocialProfiles= ABRecordCopyValue([tmpPerson recordRef], kABPersonSocialProfileProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:SocialProfiles ];
    
    if (MultiValue) {
        
        
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
        
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonSocialProfileProperty];
    
    CFRelease(MultiValue);
    CFRelease(SocialProfiles);
    
}
//***************** 6、IM信息操作 ***********************
- (void)OperIMsWithKey : (CFStringRef)key
              andValue : (NSString*) value
              andIndex : (NSUInteger)index
           andOperType : (OperationType)opertype
              inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef ims= ABRecordCopyValue([tmpPerson recordRef], kABPersonInstantMessageProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:ims ];
    
    if (MultiValue) {
        
        
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
        
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonInstantMessageProperty];
    
    CFRelease(MultiValue);
    CFRelease(ims);
    
    
}

//***************** 7、邮件信息操作 **********************
- (void)OperEmailsWithKey : (CFStringRef)key
                 andValue : (NSString*) value
                 andIndex : (NSUInteger)index
              andOperType : (OperationType)opertype
                 inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef emails= ABRecordCopyValue([tmpPerson recordRef], kABPersonEmailProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:emails ];
    
    if (MultiValue) {
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonEmailProperty];
    CFRelease(MultiValue);
    CFRelease(emails);
    
}
//***************** 8、url信息操作 **********************
- (void)OperUrlsWithKey : (CFStringRef)key
               andValue : (NSString*) value
               andIndex : (NSUInteger)index
            andOperType : (OperationType)opertype
               inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef urls= ABRecordCopyValue([tmpPerson recordRef], kABPersonURLProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:urls ];
    
    if (MultiValue) {
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonURLProperty];
    CFRelease(MultiValue);
    CFRelease(urls);
}

//***************** 9、日期信息操作 **********************
- (void)OperDatesWithKey : (CFStringRef)key
                andValue : (NSDate*) value
                andIndex : (NSUInteger)index
             andOperType : (OperationType)opertype
                inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef dates= ABRecordCopyValue([tmpPerson recordRef], kABPersonDateProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:dates ];
    
    if (MultiValue) {
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonDateProperty];
    CFRelease(MultiValue);
    CFRelease(dates);
    
    
}

//***************** 10、备注操作 *********************
- (void)OperPersonNoteWithOperType : (OperationType)opertype
                          andValue : (NSString*) value
                          inPerson : (GTMABPerson *) tmpPerson
{
    if (value) {
        if (opertype == OperationType_del) {
            [tmpPerson removeValueForProperty:kABPersonNoteProperty];
        }
        else if(opertype == OperationType_add||opertype == OperationType_edit)
            [tmpPerson setValue:value forProperty:kABPersonNoteProperty];
    }
    
    
}

//***************** 11、生日信息操作 *********************
- (void)OperBirthdayWithOperType : (OperationType)opertype
                        andValue : (NSDate*) value
                        inPerson : (GTMABPerson *) tmpPerson
{
    
    
    if (value) {
        if (opertype == OperationType_del) {
            [tmpPerson removeValueForProperty:kABPersonBirthdayProperty];
        }
        else if(opertype == OperationType_add||opertype == OperationType_edit)
            [tmpPerson setValue:value forProperty:kABPersonBirthdayProperty];
    }
}


//Mark: ========================本地通讯录 11大类操作
-(void)saveToAddrBook:(NSMutableArray*)arr
{
    
    //添加联系人
    GTMABAddressBook*    book_ = [[GTMABAddressBook addressBook:[SysAddrBook getSingleAddressBook]] retain];
    
    for (int i=0; i<[arr count]; i++) {
         VcardPersonEntity * entity= [arr objectAtIndex:i];
        GTMABPerson * tmpPerson = [GTMABPerson personWithFirstName:[entity.NameArr valueForKey:@"0"] lastName:[entity.NameArr valueForKey:@"1"]];
        [book_ addRecord:tmpPerson];
        
        for (int i=0; i<[[entity.PhoneArr allKeys] count]; i++) {
            
            NSString *phoneV = [entity.PhoneArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            NSArray * phoneVArr = [phoneV componentsSeparatedByString:@";"];
            if ([phoneVArr count]>1) {
                [self OperContactNumbersWithKey:(CFStringRef)[phoneVArr objectAtIndex:0] andValue:[phoneVArr objectAtIndex:1] andIndex:1 andOperType:OperationType_add inPerson:tmpPerson];
            }
           
        }
     
        for (int i=0; i<[[entity.AddrArr allKeys] count]; i++) {
            
            NSString *adrV = [entity.AddrArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            NSArray * adrVArr = [adrV componentsSeparatedByString:@";"];
            if ([adrVArr count]>1) {
                
                NSArray * adrDetailVArr = [[adrVArr objectAtIndex:1] componentsSeparatedByString:@"@@"];
                if ([adrDetailVArr count]>4) {
                
//                    一号,
//                    河北,
//                    石家庄,
//                    100022,
//                    中国
                CFStringRef keys[6] = {kABPersonAddressStreetKey,
                    kABPersonAddressCityKey,
                    kABPersonAddressStateKey,
                    kABPersonAddressZIPKey,
                    kABPersonAddressCountryCodeKey,
                    kABPersonAddressCountryKey
                };
                CFStringRef values[6] = {(CFStringRef)([adrDetailVArr objectAtIndex:0]),
                    (CFStringRef)([adrDetailVArr objectAtIndex:2]),
                    (CFStringRef)([adrDetailVArr objectAtIndex:1]),
                    (CFStringRef)([adrDetailVArr objectAtIndex:3]),
                     CFSTR("80424"),
                    (CFStringRef)([adrDetailVArr objectAtIndex:4])};
                CFDictionaryRef data =
                CFDictionaryCreate(NULL,
                                   (void *)keys,
                                   (void *)values,
                                   6,
                                   &kCFCopyStringDictionaryKeyCallBacks,
                                   &kCFTypeDictionaryValueCallBacks);
                
                [self OperAddressesWithKey:(CFStringRef)[adrVArr objectAtIndex:0] andValue:(id)data andIndex:1 andOperType:OperationType_add inPerson:tmpPerson];
                CFRelease(data);
                    
                }

            }
            
        }
        
        
     
        //3。相关联系人测试
       [self OperRelatedContactsWithKey:kABHomeLabel andValue:@"wwwwwwwww" andIndex:0 andOperType:OperationType_add inPerson:tmpPerson];
        
        [book_ save];
    }
    
    
//    GTMABGroup *tmpGroup = [GTMABGroup groupNamed:@"newGroup1"];
//    
//    [book_ addRecord:tmpGroup];
//    [book_ save];
//    
//    NSArray *people = [book_ people];
//    
//    for (int i=0; i<people.count; i++) {
//        GTMABPerson * tmpPerson = (GTMABPerson *)[people objectAtIndex:i];
//        if (tmpPerson) {
//            [tmpGroup addMember:tmpPerson];
//            NSString* p = [tmpGroup valueForProperty:kABGroupNameProperty];
//            printLog(@"Goupname:%@",p);
//            
//            [tmpPerson setImage:[UIImage imageNamed:@"Default.png"]];
//            if (1)
//            {
//                //1。基本信息测试
//                [self OperBasicInfoWithProperty:kABPersonNicknameProperty andValue:@"test nikname" andOperType:OperationType_add inPerson:tmpPerson];
//                //1。基本信息测试
//                [self OperBasicInfoWithProperty:kABPersonFirstNameProperty andValue:@"wwb" andOperType:OperationType_add inPerson:tmpPerson];
//                
//                
//                //2。号码测试
//                [self OperContactNumbersWithKey:(CFStringRef)@"zidingyi" andValue:@"111111111" andIndex:1 andOperType:OperationType_edit inPerson:tmpPerson];
//                //            [self OperContactNumbersWithKey:kABHomeLabel andValue:@"999999999" andIndex:0 andOperType:OperationType_edit inPerson:tmpPerson];
//                
//                //            [self OperContactNumbersWithKey:kABHomeLabel andValue:@"999999999" andIndex:0 andOperType:OperationType_del inPerson:tmpPerson];
//                
//                //3。相关联系人测试
//                [self OperRelatedContactsWithKey:@"zidingyi" andValue:@"wwwwwwwww" andIndex:0 andOperType:OperationType_add inPerson:tmpPerson];
//                
//                //4.地址测试
//                
//                
//                CFStringRef keys[6] = {kABPersonAddressStreetKey,
//                    kABPersonAddressCityKey,
//                    kABPersonAddressStateKey,
//                    kABPersonAddressZIPKey,
//                    kABPersonAddressCountryCodeKey,
//                    kABPersonAddressCountryKey
//                };
//                CFStringRef values[6] = {CFSTR("765 Four St."),
//                    CFSTR("Fivesville"),
//                    CFSTR("Fivesville222"),
//                    CFSTR("80424"),
//                    CFSTR("9999999"),
//                    CFSTR("china")};
//                CFDictionaryRef data1 =
//                CFDictionaryCreate(NULL,
//                                   (void *)keys,
//                                   (void *)values,
//                                   6,
//                                   &kCFCopyStringDictionaryKeyCallBacks,
//                                   &kCFTypeDictionaryValueCallBacks);
//                
//                [self OperAddressesWithKey:kABHomeLabel andValue:(id)data1 andIndex:1 andOperType:OperationType_add inPerson:tmpPerson];
//                CFRelease(data1);
//                
//                
//                //5.社交信息测试
//                
//                CFStringRef keys1[2] = {kABPersonSocialProfileServiceKey,
//                    kABPersonSocialProfileUsernameKey};
//                CFStringRef values1[2] = {CFSTR("zidingyi"),
//                    CFSTR("sssff")};
//                CFDictionaryRef  data =
//                CFDictionaryCreate(NULL,
//                                   (void *)keys1,
//                                   (void *)values1,
//                                   2,
//                                   &kCFCopyStringDictionaryKeyCallBacks,
//                                   &kCFTypeDictionaryValueCallBacks);
//                [self OperNetSocialWithKey: kABHomeLabel andValue:(id)data andIndex:3 andOperType:OperationType_edit inPerson:tmpPerson];
//                
//                
//                
//                //6.ims测试
//                CFStringRef keys2[2] = {kABPersonInstantMessageUsernameKey,
//                    kABPersonInstantMessageServiceKey
//                };
//                CFStringRef values2[2] = {CFSTR("765@yahoo.com"),kABPersonInstantMessageServiceYahoo};
//                CFDictionaryRef data2 =
//                CFDictionaryCreate(NULL,
//                                   (void *)keys2,
//                                   (void *)values2,
//                                   2,
//                                   &kCFCopyStringDictionaryKeyCallBacks,
//                                   &kCFTypeDictionaryValueCallBacks);
//                [self OperIMsWithKey:kABHomeLabel andValue:(id)data2 andIndex:0 andOperType:OperationType_add inPerson:tmpPerson];
//                
//                
//                //7。邮件测试
//                [self OperEmailsWithKey:(CFStringRef)@"zidingyi" andValue:(id)@"111111111@qq.com" andIndex:1 andOperType:OperationType_add inPerson:tmpPerson];
//                
//                //8。urls测试
//                [self OperUrlsWithKey:kABPersonHomePageLabel andValue:(id)@"http://wwww.hao.com" andIndex:0 andOperType:OperationType_edit inPerson:tmpPerson];
//                
//                
//                //9.日期测试
//                
//                [self OperDatesWithKey:kABPersonAnniversaryLabel andValue:[NSDate date] andIndex:0 andOperType:OperationType_edit inPerson:tmpPerson];
//                
//                //10.备注测试
//                [self OperPersonNoteWithOperType:OperationType_edit andValue:(id)@"哈哈" inPerson:tmpPerson];
//                
//                //11.生日测试
//                [self OperBirthdayWithOperType:OperationType_edit andValue:[NSDate date] inPerson:tmpPerson];
//                
//            }
//            NSLog(@"key:%@ value:%@", @"kABPersonModificationDateProperty",(NSString*)ABRecordCopyValue([tmpPerson recordRef],kABPersonModificationDateProperty));
//            
//            
//            
//            
//            [book_ save];
//            continue;
//            
//            
//            
//            
//            [book_ save];
//        }
//    }
    
    
    
    
    
    
    [book_ release];



}
-(void)loadFromAddrBook:(NSMutableArray*)arr
{

	ABAddressBookRef		addrBook= [SysAddrBook getSingleAddressBook];
    @synchronized(self)
    {
        NSArray* arrRecord= (NSArray*)ABAddressBookCopyArrayOfAllPeople(addrBook);
        
        if (arr && arrRecord && [arrRecord count]>0)
        {
            ABRecordRef	 record;
            NSEnumerator *enumtator= [arrRecord objectEnumerator];
            
            while (record= [enumtator nextObject])
            {
//                NSAutoreleasePool *poolWhile= [[NSAutoreleasePool alloc] init];
                ABRecordID	idRecord= ABRecordGetRecordID(record);
                VcardPersonEntity * entity= [[VcardPersonEntity alloc] init];
                
                
                entity.ID= [NSString stringWithFormat:@"%d", idRecord];
                NSString *tmp =(NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
                if ([tmp length]>0) {
                    [entity.NameArr setValue:tmp forKey:@"0"];
                     NSLog(@"firstname value:%@",tmp);
                }
                tmp =(NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
                if ([tmp length]>0) {
                    [entity.NameArr setValue:tmp forKey:@"1"];
                     NSLog(@"lastname value:%@",tmp);
                }
                
              
                

                {
                    ABMultiValueRef mails=	ABRecordCopyValue(record, kABPersonEmailProperty);
                    NSInteger		count1=	ABMultiValueGetCount(mails);
                    if (mails && count1>0)
                    {

                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(mails);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            NSString*	lable= (NSString*)ABMultiValueCopyLabelAtIndex(mails, nIndex);
                            NSString*	email= (NSString*)ABMultiValueCopyValueAtIndex(mails, nIndex);
                            if (lable && email)
                            {
                                [entity.EmailArr setValue:[NSString stringWithFormat:@"%@;%@",lable,email] forKey:[NSString stringWithFormat:@"%ld",nIndex]];
                                NSLog(@"EmailArr value:%@",[NSString stringWithFormat:@"%@;%@",lable,email]);
                                
                            }
                            
                            [lable release];
                            [email release];
                        }

                        
                    }
                    CFRelease(mails);
                    
                    
                    
                    ABMultiValueRef phones= ABRecordCopyValue(record, kABPersonPhoneProperty);
                    
                    count1= ABMultiValueGetCount(phones);
                    if (phones && count1>0)
                    {
                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(phones);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            NSString*	lable= (NSString*)ABMultiValueCopyLabelAtIndex(phones, nIndex);
                            NSString*	phone= (NSString*)ABMultiValueCopyValueAtIndex(phones, nIndex);
                            if (lable && phone)
                            {
                                NSArray		*arr= [phone componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()- "]];
                                
                                NSString	*phoneNum= [arr componentsJoinedByString:@""];
                                NSString *lTmp = [NSString stringWithFormat:@"%s"," "];
                                phoneNum=[phoneNum stringByReplacingOccurrencesOfString:lTmp withString:@""];
                                
                                
                                [entity.PhoneArr setValue:[NSString stringWithFormat:@"%@;%@",lable,phoneNum] forKey:[NSString stringWithFormat:@"%ld",nIndex]];
                                
                                NSLog(@"PhoneArr value:%@",[NSString stringWithFormat:@"%@;%@",lable,phoneNum]);

                                
                            }
                            
                            [lable release];
                            [phone release];
                        }
                    }
                    CFRelease(phones);
                    
                    //helei 2011-4-25
                    //读网页
                    ABMultiValueRef  urls= ABRecordCopyValue(record, kABPersonURLProperty);
                    
                    count1= ABMultiValueGetCount(urls);
                    if (urls && count1>0)
                    {
                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(urls);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            NSString*	lable= (NSString*)ABMultiValueCopyLabelAtIndex(urls, nIndex);
                            NSString*	url= (NSString*)ABMultiValueCopyValueAtIndex(urls, nIndex);
                            if (lable && url)
                            {
                                [entity.URLArr setValue:[NSString stringWithFormat:@"%@;%@",lable,url] forKey:[NSString stringWithFormat:@"%ld",nIndex]];
                                 NSLog(@"URLArr value:%@",[NSString stringWithFormat:@"%@;%@",lable,url]);
                                
                            }
                            
                            [lable release];
                            [url release];
                        }
                    }
                    CFRelease(urls);
                    //读地址
                    ABMultiValueRef address= ABRecordCopyValue(record, kABPersonAddressProperty);
                    
                    count1= ABMultiValueGetCount(address);
                    if (address && count1>0)
                    {
                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(address);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            NSMutableString *adstr =[NSMutableString stringWithCapacity:5];
                            //获取地址Label
                            NSString* lable = (NSString*)ABMultiValueCopyLabelAtIndex(address, nIndex);
   
                            //获取該label下的地址6属性
                            NSDictionary* personaddress =(NSDictionary*) ABMultiValueCopyValueAtIndex(address, nIndex);
                            
                            
                            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
                            if(street != nil)
                            {
                                [adstr appendString:street];
                                [adstr appendString:@"@@"];
                            }
                            else
                            {
                                [adstr appendString:@""];
                                [adstr appendString:@"@@"];
                            }
                            
                            
                            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
                            if(state != nil)
                            {
                                [adstr appendString:state];
                                [adstr appendString:@"@@"];
                            }
                            else
                            {
                                [adstr appendString:@""];
                                [adstr appendString:@"@@"];
                            }
                            
                            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
                            if(city != nil)
                            {
                                [adstr appendString:city];
                                [adstr appendString:@"@@"];
                            }
                            else
                            {
                                [adstr appendString:@""];
                                [adstr appendString:@"@@"];
                            }
                            
                            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
                            if(zip != nil)
                            {
                                [adstr appendString:zip];
                                [adstr appendString:@"@@"];
                            }
                            else
                            {
                                [adstr appendString:@""];
                                [adstr appendString:@"@@"];
                            }

                            
                            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
                            
                            if(country != nil)
                            {
                                [adstr appendString:country];
//                                [adstr appendString:@"@@"];
                            }
                            else
                            {
                                [adstr appendString:@""];
//                                [adstr appendString:@"@@"];
                            }
                            
                            if (lable && adstr)
                            {
                                [entity.AddrArr setValue:[NSString stringWithFormat:@"%@;%@",lable,adstr] forKey:[NSString stringWithFormat:@"%ld",nIndex]];
                                 NSLog(@"AddrArr value:%@",[NSString stringWithFormat:@"%@;%@",lable,adstr]);
                                
                            }
                        }
                    }
                    CFRelease(address);
                    
                    
                    //im
                    
                    ABMultiValueRef InstantMessage= ABRecordCopyValue(record, kABPersonInstantMessageProperty);
                    
                    count1= ABMultiValueGetCount(InstantMessage);
                    if (InstantMessage && count1>0)
                    {
                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(InstantMessage);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            
                            
                            NSDictionary* personInstantMessage =(NSDictionary*) ABMultiValueCopyValueAtIndex(InstantMessage, nIndex);
                            
                            //NSLog(@"id:%d",ABMultiValueGetIdentifierAtIndex(InstantMessage, nIndex));
                            
                              NSString* lable = (NSString*)ABMultiValueCopyLabelAtIndex(InstantMessage, nIndex);
                            
                            NSArray * keys = [personInstantMessage allKeys];
                            if (2<=[keys count])
                            {
                                
                                NSMutableString * str = [NSMutableString stringWithCapacity:50];
                                [str appendString:[personInstantMessage valueForKey:[keys objectAtIndex:1]]];
                                [str appendString:@"("];
                                  [str appendString:[personInstantMessage valueForKey:[keys objectAtIndex:0]]];
                                [str appendString:@")"];
                                
                              
                                
                                 [entity.AIMArr setValue:[NSString stringWithFormat:@"%@;%@",lable,str] forKey:[NSString stringWithFormat:@"%ld",nIndex]];
                                NSLog(@"im value:%@",[NSString stringWithFormat:@"%@;%@",lable,str]);
                                
                            }
                            
                            
                            
                        }
                        
                    }
                    CFRelease(InstantMessage);
                    
                    
                    
                    
             
                    [arr addObject:entity];
                }
                
                
                
                [entity release];
        
//                [poolWhile release];
            }
        }
    }
	
	
}

-(void)paraseVcard:(NSString*)filepath :(NSMutableArray *)vcardArr
{
    NSFileManager	*fileManager=	[NSFileManager defaultManager];
    BOOL			isExist=		[fileManager fileExistsAtPath:filepath];
    NSString *vcf = nil;
    NSArray  * arr;
    if (isExist) {
        NSError * error= nil;
        vcf = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"astring:%@",vcf);
        arr = [vcf componentsSeparatedByString:@"\r\n"];
    }
//     NSMutableArray * vcardArr = [NSMutableArray array];
     VcardPersonEntity * vcardEntity = nil;
    for (int i=0; i<[arr count]; i++) {
       
        NSString *str = (NSString*)[arr objectAtIndex:i];
         NSLog(@"****line:%d str:%@",i,str);
        if ([str isEqualToString:@"BEGIN:VCARD"]) {
            vcardEntity = [[VcardPersonEntity alloc] init];
        }
       if (vcardEntity) {
            
            //N:xs;mz;zjm;cw;qtcw
            NSArray *namearr = [str componentsSeparatedByString:@":"];
            if ([str hasPrefix:@"N:"])
            {
                NSString *name = (NSString *)[namearr lastObject];
                NSArray *namesArr = [name componentsSeparatedByString:@";"];
                for (int i=0; i<[namesArr count]; i++) {
                    [vcardEntity.NameArr setValue:[namesArr objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d", i]];
                }
                
                 NSLog(@"****NAME:%@",name);
                
            }
             NSArray *Adrarr = [str componentsSeparatedByString:@":"];
            if ([str hasPrefix:@"ADR"])
            {
                NSString *adr = (NSString *)[Adrarr lastObject];
                NSArray *adrsArr = [adr componentsSeparatedByString:@";"];
                
                NSString *adrV = [NSString stringWithFormat:@"%@;%@",[self getAdrBookType:str],[adrsArr componentsJoinedByString:@"@@"]];
                [vcardEntity.NameArr setValue:adrV forKey:[NSString stringWithFormat:@"%d", [vcardEntity.NameArr count]]];
                    
               
                NSLog(@"****ADR:%@",adr);
                
                
                
            }

            
            
            NSArray *arr = [str componentsSeparatedByString:@";"];
           
            if ([arr count]>0) {
                
                

                if ([str hasPrefix:@"TEL"])
                {
                    NSString *phone = (NSString *)[arr objectAtIndex:[arr count]-1];
                    NSArray *phonesArr = [phone componentsSeparatedByString:@":"];
                    if ([phonesArr count]>0) {
                        NSString *phoneV = [NSString stringWithFormat:@"%@;%@",[self getAdrBookType:str],[phonesArr objectAtIndex:1]];
                        [vcardEntity.PhoneArr setValue:phoneV forKey:[NSString stringWithFormat:@"%d", [vcardEntity.PhoneArr count]]];
                        NSLog(@"****TEL:%@",[phonesArr objectAtIndex:1]);
                    }

                }
                
                
                if ([str hasPrefix:@"URL"])
                {
                    NSString *url = (NSString *)[arr objectAtIndex:[arr count]-1];
                    NSArray *urlsArr = [url componentsSeparatedByString:@":"];
                    if ([urlsArr count]>0) {
                        [vcardEntity.URLArr setValue:[urlsArr objectAtIndex:1] forKey:[NSString stringWithFormat:@"%d", [vcardEntity.URLArr count]]];
                        NSLog(@"****URL:%@",url);
                    }
                    
                }
                if ([str hasPrefix:@"X-AIM"])
                {
                    NSString *aim = (NSString *)[arr objectAtIndex:[arr count]-1];
                    NSArray *aimArr = [aim componentsSeparatedByString:@":"];
                    if ([aimArr count]>0) {
                        [vcardEntity.AIMArr setValue:[aimArr objectAtIndex:1] forKey:[NSString stringWithFormat:@"%d", [vcardEntity.AIMArr count]]];
                         NSLog(@"****AIM:%@",[aimArr objectAtIndex:1]);
                    }
                    
                }
                if ([str hasPrefix:@"X-SOCIALPROFILE"])
                {
                    NSString *social = (NSString *)[arr objectAtIndex:[arr count]-1];
                    NSArray *socialArr = [social componentsSeparatedByString:@":"];
                    if ([socialArr count]>0) {

                        
                        [vcardEntity.SocialArr setValue:[socialArr objectAtIndex:1] forKey:[NSString stringWithFormat:@"%d", [vcardEntity.SocialArr count]]];
                        NSLog(@"****SOCIAL:%@",social);
                    }
                    
                }
               
                if ([str hasPrefix:@"EMAIL"])
                {
                    NSString *email = (NSString *)[arr objectAtIndex:[arr count]-1];
                    NSArray *emailsArr = [email componentsSeparatedByString:@":"];
                    if ([emailsArr count]>0) {

                          [vcardEntity.EmailArr setValue:[emailsArr objectAtIndex:1] forKey:[NSString stringWithFormat:@"%d", [vcardEntity.EmailArr count]]];
                        NSLog(@"****EMAIL:%@",[emailsArr objectAtIndex:1]);
                    }
                    
                }



            }
            
        }
        
        if ([str isEqualToString:@"END:VCARD"]) {
            if (vcardEntity) {
                [vcardArr addObject:vcardEntity];
                [vcardEntity release];
                vcardEntity = nil;
                 NSLog(@"****===============");
          }
        }
    }



}
-(CFStringRef)getAdrBookType:(NSString*)str
{

    
    if ([str rangeOfString:kLABLE_HOME].location != NSNotFound)  {
            return kABHomeLabel;
    }
    else if ([str rangeOfString:kLABLE_WORK].location != NSNotFound)  {
            return kABWorkLabel;
    }
    else if ([str rangeOfString:kLABLE_MAIN].location != NSNotFound)  {
            return kABPersonPhoneMainLabel;
    }
    else if ([str rangeOfString:kLABLE_PAGER].location != NSNotFound)  {
            return kABPersonPhonePagerLabel;
    }
    else
    {
            return kABOtherLabel;
    }
    
    
    
  


}



-(void)createVcard
{
//BEGIN:VCARD
//VERSION:2.1
//PRODID:-//Apple Inc.//Mac OS X 10.8.2//EN
//N:xs;mz;zjm;cw;qtcw
//FN:cw mz zjm xs qtcw
//NICKNAME:nc
//    X-MAIDENNAME:xs
//    X-PHONETIC-MIDDLE-NAME:zjmjp
//    X-PHONETIC-LAST-NAME:xsjp
//ORG:gs;bm
//TITLE:zw
//    EMAIL;INTERNET;HOME;pref:wwb113@qq.com
//    EMAIL;INTERNET;WORK:wwb112@qq.com
//    EMAIL;INTERNET:wwb113@qq.com
//    TEL;CELL;VOICE;pref:15810330913
//    TEL;IPHONE;CELL;VOICE:15810330914
//    TEL;HOME;VOICE:11111
//    TEL;WORK;VOICE:11444
//    TEL;MAIN:113444
//    TEL;HOME;FAX:22222
//    TEL;WORK;FAX:2224344
//    TEL;OTHER;FAX:22434
//    TEL;PAGER:22222
//TEL:222
//    TEL;OTHER;VOICE:333
//    ADR;HOME;pref;CHARSET=UTF-8:;;东三环;北京;北京;100000;中国
//    X-SOCIALPROFILE;twitter:http://twitter.com/222
//    X-SOCIALPROFILE;facebook:http://facebook.com/222
//    X-SOCIALPROFILE;flickr:http://www.flickr.com/photos/333
//    X-SOCIALPROFILE;linkedin:http://www.linkedin.com/in/333
//    X-SOCIALPROFILE;myspace:http://www.myspace.com/333
//    X-SOCIALPROFILE;sinaweibo:http://weibo.com/n/333
//    NOTE;CHARSET=UTF-8:生生世世是
//    URL;pref:http://www.222.com
//    URL;HOME:http://www.222.com
//    URL;WORK:http://www.222.com
//URL:http://www.222.com
//BDAY:1982-07-09
//    X-AIM;HOME;pref:111
//    X-AIM;WORK:1122
//    X-AIM:2233
//    IMPP;AIM;HOME;pref:aim:111
//    IMPP;AIM;WORK:aim:1122
//    IMPP;AIM:aim:2233
//UID:39396744-dfb1-47c7-b5d8-a736f066f57d
//    X-ABUID:39396744-DFB1-47C7-B5D8-A736F066F57D:ABPerson
//END:VCARD
    
    NSMutableArray * vcf = [NSMutableArray array];
//    [vcf addObject:@"BEGIN:VCARD"];
//    [vcf addObject:@"VERSION:2.1"];
//    [vcf addObject:@"PRODID:-//Apple Inc.//Mac OS X 10.8.2//EN"];
//    [vcf addObject:@"N:xs;mz2;zjm;cw;qtcw"];
//    [vcf addObject:@"FN:cw mz zjm xs qtcw"];
//    [vcf addObject:@"NICKNAME:nc"];
//    [vcf addObject:@"EMAIL;INTERNET:wwb113@qq.com"];
//    [vcf addObject:@"TEL;HOME;VOICE:11111"];
//    [vcf addObject:@"ADR;HOME;pref;CHARSET=UTF-8:;;东三环;北京;北京;100000;中国"];
//    [vcf addObject:@"URL;WORK:http://www.222.com"];
//    [vcf addObject:@"END:VCARD"];



    NSMutableArray * arr = [NSMutableArray array];
    [self loadFromAddrBook:arr];
    for (int i=0; i<[arr count]; i++) {
        VcardPersonEntity * entity= [arr objectAtIndex:i];
        //一个vcard
        [vcf addObject:@"BEGIN:VCARD"];
        [vcf addObject:@"VERSION:2.1"];
        [vcf addObject:@"PRODID:-//Apple Inc.//Mac OS X 10.8.2//EN"];
        NSMutableArray * nameArr = [NSMutableArray array];
        for (int i=0; i<[[entity.NameArr allKeys] count]; i++) {
            [nameArr addObject:[entity.NameArr objectForKey:[NSString stringWithFormat:@"%d",i]]];
        }

        [vcf addObject:[NSString stringWithFormat:@"N:%@",[nameArr componentsJoinedByString:@";"]]];
        [vcf addObject:@"FN:cw mz zjm xs qtcw"];
        [vcf addObject:@"NICKNAME:nc"];
        
       
        for (int i=0; i<[[entity.PhoneArr allKeys] count]; i++) {
            NSMutableArray * phoneArr = [NSMutableArray array];
            [phoneArr addObject:@"TEL;IPHONE;CELL;VOICE"];

            NSString *phoneV = [entity.PhoneArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            [phoneArr addObject:[[phoneV componentsSeparatedByString:@";"] lastObject]];
            
            [vcf addObject:[phoneArr componentsJoinedByString:@":"]];
        }
        
        for (int i=0; i<[[entity.EmailArr allKeys] count]; i++) {
            NSMutableArray * emailArr = [NSMutableArray array];
            [emailArr addObject:@"EMAIL;INTERNET;WORK"];
            
            NSString *emailV = [entity.EmailArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            [emailArr addObject:[[emailV componentsSeparatedByString:@";"] lastObject]];
            
            [vcf addObject:[emailArr componentsJoinedByString:@":"]];
        }
        
        for (int i=0; i<[[entity.URLArr allKeys] count]; i++) {
            NSMutableArray * urlArr = [NSMutableArray array];
            [urlArr addObject:@"URL;pref"];
            
            NSString *urlV = [entity.URLArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            [urlArr addObject:[[urlV componentsSeparatedByString:@";"] lastObject]];
            
            [vcf addObject:[urlArr componentsJoinedByString:@":"]];
        }
        
        for (int i=0; i<[[entity.AddrArr allKeys] count]; i++) {
            //;;东三环;北京;北京;100000;中国
            NSMutableArray * addrArr = [NSMutableArray array];
            [addrArr addObject:@"ADR;HOME;pref;CHARSET=UTF-8"];
            
            NSString *adrV = [entity.AddrArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            [addrArr addObject:[[[[adrV componentsSeparatedByString:@";"] lastObject] componentsSeparatedByString:@"@@"] componentsJoinedByString:@";"]];
            
            [vcf addObject:[addrArr componentsJoinedByString:@":"]];
        }

    
        [vcf addObject:@"END:VCARD"];
    }
    
    NSString* vcfStr = [vcf componentsJoinedByString:@"\r\n"];
    NSLog(@"vcfStr:%@",vcfStr);
    

    //创建文件管理器
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    
    //获取document路径,括号中属性为当前应用程序独享
    
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,      NSUserDomainMask, YES);
    
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    
    
    
    //定义记录文件全名以及路径的字符串filePath
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"contact.vcf"];
    
    
    
    //查找文件，如果不存在，就创建一个文件
    
    if (![fileManager fileExistsAtPath:filePath]) {
         [vcfStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
//        [fileManager createFileAtPath:filePath contents:[[NSData alloc] in] attributes:nil];
        
    }

}

-(void)loadViewBylua
{
    wax_end();
    wax_start("init.lua",nil);
//    wax_start("StatesTable.lua", luaopen_wax_http, luaopen_wax_json, luaopen_wax_xml, nil);
}

-(void)startThread
{

    // 锁对象
    ticketsCondition = [[NSCondition alloc] init];
    ticketsThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [ticketsThreadone setName:@"Thread-1"];
    [ticketsThreadone start];
    
    
    ticketsThreadtwo = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [ticketsThreadtwo setName:@"Thread-2"];
    [ticketsThreadtwo start];
    //[NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];

}


-(void)stopThread
{
    [ticketsThreadtwo cancel];
    [ticketsThreadtwo release];
    ticketsThreadtwo = nil;
    [ticketsThreadone cancel];
    [ticketsThreadone release];
    ticketsThreadone = nil;
    
    
    if (ticketsThreadtwo.isExecuting) {
           NSLog(@"线程名:%@ isExecuting",[[NSThread currentThread] name]);
    }
    
}
- (void)run{
    while (TRUE) {
     	// 上锁
        [ticketsCondition lock];
        if(tickets > 0&&[[NSThread currentThread] isCancelled] == NO){
            [NSThread sleepForTimeInterval:0.5];
            count = 100 - tickets;
            NSLog(@"当前票数是:%d,售出:%d,线程名:%@",tickets,count,[[NSThread currentThread] name]);
            tickets--;
        }else{
            break;
        }
        [ticketsCondition unlock];
    }
}

- (void)dealloc {
	[ticketsThreadone release];
    [ticketsThreadtwo release];
    [ticketsCondition release];
    [super dealloc];
}

-(IBAction)flipButtonClicked:(id)sender
{
//    CGRect viewRect = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
//    UIView *containerView  = [[UIView alloc] initWithFrame:viewRect];
////    containerView.center = self.view.center;
//    
//    
//    UIImageView* frontImageView = [[UIImageView alloc] initWithImage:[UIImage
//                                                                     imageNamed:@"bubbleMine.png"]];
//    frontImageView.center = containerView.center;
//    [containerView addSubview:frontImageView];
//    
//    UIImageView* backImageView = [[UIImageView alloc] initWithImage:[UIImage
//                                                        imageNamed:@"bubbleSomeone.png"]];
//    backImageView.center = frontImageView.center;
//    [containerView addSubview:backImageView];
//    [self.view addSubview:containerView];
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:1.0];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
//                           forView:containerView
//                             cache:YES];
////    [frontImageView removeFromSuperview];
////    [containerView addSubview:backImageView];
//    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
//    [UIView commitAnimations];
//    
//    [frontImageView release];
//    [backImageView release];
//    [containerView release];

    

    [UIView beginAnimations:@"moveup" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:containerView
                             cache:YES];
    if (!isFlip) {
        isFlip = YES;
        [frontImageView removeFromSuperview];
        [containerView addSubview:backImageView];
    }
    else{
        isFlip = NO;
        [backImageView removeFromSuperview];
        [containerView addSubview:frontImageView];
    }
    [UIView setAnimationDidStopSelector:@selector(animationMoveDidStop)];
    [UIView commitAnimations];

    
    
}

/*
 *UIView动画结束后的默认通知方法
 */
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"moveup"] == NSOrderedSame)
    {
        [self deleteanimationView:containerView FromPoint:CGPointMake(0,0) ToPoint:CGPointMake(200,200)];
    
        //播放其他的动画
    }
    //TODO：其他的动画结束判断
}

-(void) deleteanimationView:(UIView*)aniView FromPoint:(CGPoint)fromPoint ToPoint:(CGPoint)toPoint
{
    aniView.hidden = NO;
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];

    [movePath addQuadCurveToPoint:toPoint
      controlPoint:CGPointMake(toPoint.x,fromPoint.y)];


    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = YES;

    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    scaleAnim.removedOnCompletion = YES;

    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
    opacityAnim.removedOnCompletion = YES;

    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim,opacityAnim, nil];
    animGroup.duration = 1;
    [aniView.layer addAnimation:animGroup forKey:nil];
    //aniView.hidden = YES;
}

- (UIImageView *) flipImage:(UIImageView *)originalImage Horizontal:(BOOL)flipHorizontal {
    if (flipHorizontal) {
        
        originalImage.transform = CGAffineTransformMake(originalImage.transform.a * -1, 0, 0, 1, originalImage.transform.tx, 0);
    }else {
        
        originalImage.transform = CGAffineTransformMake(1, 0, 0, originalImage.transform.d * -1, 0, originalImage.transform.ty);
    }    
    return originalImage;

}

- (CAGradientLayer *)shadowAsInverse:(CGRect)rect
{  
    CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];  
    CGRect newShadowFrame = CGRectMake(0, 0, rect.size.width, rect.size.height);  
    newShadow.frame = newShadowFrame;  
    //添加渐变的颜色组合  
    newShadow.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor blackColor].CGColor,nil];  
    return newShadow;  
}  
-(void)viewWillAppear:(BOOL)animated
{
   //[[AppDelegate sharedApplication] hiddenTabBar:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    // Release any retained subviews of the main view.
}

-(void)push
{
//    ViewController* homeViewController_ = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    [self.navigationController pushViewController:homeViewController_ animated:YES];
//    [homeViewController_ release];
    
    
    ViewController* viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    nav = [UINavigationController alloc];
//    ViewController *vc = viewController;
    
    // manually trigger the appear method
    [viewController viewDidAppear:YES];
    
//    vc.launcherImage = launcher;
    [nav initWithRootViewController:viewController];
    [nav viewDidAppear:YES];
    
    nav.view.alpha = 0.f;
    nav.view.transform = CGAffineTransformMakeScale(.1f, .1f);
    [self.view addSubview:nav.view];
    
    [UIView animateWithDuration:.3f  animations:^{
        // fade out the buttons
//        for(SEMenuItem *item in self.items) {
//            item.transform = [self offscreenQuadrantTransformForView:item];
//            item.alpha = 0.f;
//        }
        
        // fade in the selected view
        nav.view.alpha = 1.f;
        nav.view.transform = CGAffineTransformIdentity;
        [nav.view setFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        // fade out the top bar
//        [navigationBar setFrame:CGRectMake(0, -44, 320, 44)];
    }];
    
    [viewController release];
}

- (void)closeViewEventHandler: (NSNotification *) notification {
    UIView *viewToRemove = (UIView *) notification.object;    
    [UIView animateWithDuration:.3f animations:^{
        viewToRemove.alpha = 0.f;
        viewToRemove.transform = CGAffineTransformMakeScale(.1f, .1f);
//        for(SEMenuItem *item in self.items) {
//            item.transform = CGAffineTransformIdentity;
//            item.alpha = 1.f;
//        }
//        [navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
    } completion:^(BOOL finished) {
        [viewToRemove removeFromSuperview];
    }];
    
    // release the dynamically created navigation bar
    [nav release];
}

@end
