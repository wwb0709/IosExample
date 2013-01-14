//
//  BackRecoverViewController.m
//  Example
//
//  Created by wangwb on 13-1-14.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import "BackRecoverViewController.h"
#import "SysAddrBookManager.h"

@interface BackRecoverViewController ()

@end

@implementation BackRecoverViewController

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
    
    httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	[httpServer setPort:8081];
	[httpServer setName:@"Example"];
    [httpServer setDocumentRoot:[NSURL fileURLWithPath:[DAUtility getVcfDir]]];

    NSError *error;
	if(![httpServer start:&error])
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAddressBook:(id)sender {
    
    [SysAddrBookManager createVcard];
}

- (IBAction)recoverAddressBook:(id)sender {
    NSString *filePath = @"/Users/wwb/Library/Application Support/iPhone Simulator/6.0/Applications/E0337306-29E1-420D-AE3D-E253CFDBC64B/Documents/vcf/20130114165616.vcf";
    [SysAddrBookManager recoverAddressBookFormVcard:filePath];
}

- (void)dealloc {
	[httpServer release];
    [super dealloc];
}
@end
