//
//  ViewController.m
//
//  Created by Alex Barinov
//  StexGroup, LLC
//  http://www.stexgroup.com
//
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "ViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    bubbleTable.bubbleDataSource = self;
    
    bubbleData = [[NSMutableArray alloc] initWithObjects:
                  [NSBubbleData dataWithText:@"Marge, there's something that I want to ask you, but I'm afraid, because if you say no, it will destroy me and make me a criminal." andDate:[NSDate dateWithTimeIntervalSinceNow:-300] andType:BubbleTypeMine],
                  [NSBubbleData dataWithText:@"Well, I haven't said no to you yet, have I?" andDate:[NSDate dateWithTimeIntervalSinceNow:-280] andType:BubbleTypeSomeoneElse],
                  [NSBubbleData dataWithText:@"Marge... Oh, damn it." andDate:[NSDate dateWithTimeIntervalSinceNow:0] andType:BubbleTypeMine],
                  [NSBubbleData dataWithText:@"What's wrong?" andDate:[NSDate dateWithTimeIntervalSinceNow:300]  andType:BubbleTypeSomeoneElse],
                  [NSBubbleData dataWithText:@"Ohn I wrote down what I wanted to say on a card.." andDate:[NSDate dateWithTimeIntervalSinceNow:395]  andType:BubbleTypeMine],
                  [NSBubbleData dataWithText:@"The stupid thing must have fallen out of my pocket." andDate:[NSDate dateWithTimeIntervalSinceNow:400]  andType:BubbleTypeMine],
                  nil];
    
    //右按钮
    UIButton *tmpTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpTabBtn setFrame:CGRectMake(0, 0, 55, 37)];
    tmpTabBtn.titleLabel.text= @"push";
    [tmpTabBtn addTarget:self
                  action:@selector(push)
        forControlEvents:UIControlEventTouchUpInside];
    tmpTabBtn.backgroundColor=[UIColor clearColor];
    [tmpTabBtn setBackgroundImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
    [tmpTabBtn setBackgroundImage:[UIImage imageNamed:@"collect_h.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem * tmpBarBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpTabBtn];
    
    self.navigationItem.rightBarButtonItem = tmpBarBtn;
    [tmpBarBtn release];
    
    {
        //右按钮
        UIButton *tmpTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tmpTabBtn setFrame:CGRectMake(0, 0, 55, 37)];
        tmpTabBtn.titleLabel.text= @"pop";
        [tmpTabBtn addTarget:self
                      action:@selector(pop)
            forControlEvents:UIControlEventTouchUpInside];
        tmpTabBtn.backgroundColor=[UIColor clearColor];
        [tmpTabBtn setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        [tmpTabBtn setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateHighlighted];
        UIBarButtonItem * tmpBarBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpTabBtn];
        
        self.navigationItem.leftBarButtonItem = tmpBarBtn;
        [tmpBarBtn release];
    }
    
//    [[AppDelegate sharedApplication] hiddenTabBar:YES];

    
}
-(void)push
{
    ViewController* homeViewController_ = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:homeViewController_ animated:YES];
    [homeViewController_ release];
    
//    [[AppDelegate sharedApplication] hiddenTabBar:YES];
}

-(void)pop
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeView" object:self.navigationController.view];
//    [[AppDelegate sharedApplication] hiddenTabBar:NO];
    
//    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
//   [[AppDelegate sharedApplication] hiddenTabBar:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
//    [[AppDelegate sharedApplication] hiddenTabBar:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
//    [[AppDelegate sharedApplication] hiddenTabBar:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

@end
