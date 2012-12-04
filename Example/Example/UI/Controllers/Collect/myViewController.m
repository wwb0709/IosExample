//
//  ViewController.m
//  Demo
//
//  Created by 张玺 on 12-11-25.
//  Copyright (c) 2012年 张玺. All rights reserved.
//

#import "ViewController.h"
#import "InputViewController.h"

@implementation ViewController



- (IBAction)edit:(id)sender {
    
    InputViewController *input = [[InputViewController alloc] initWithNibName:@"InputViewController" bundle:nil];
    [self presentModalViewController:input animated:YES];
    
    
    
    //看这里
    [input receiveObject:^(id object) {
        
        _result.text = object;
        
    }];
    
}

//下面没用


























- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setResult:nil];
    [super viewDidUnload];
}
@end
