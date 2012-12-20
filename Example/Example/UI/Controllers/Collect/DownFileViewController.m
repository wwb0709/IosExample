//
//  DownFileViewController.m
//  Example
//
//  Created by wangwb on 12-12-20.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import "DownFileViewController.h"
#import "FileTranserHelper.h"
#import "FileTranserModel.h"
@interface DownFileViewController ()
{
        BOOL isLoading;
}
@property(nonatomic,retain)UITableView *downingTableView;
@property(nonatomic,retain)NSMutableArray *downinglist;
@property(nonatomic,retain)EGORefreshTableHeaderView *headerView;
@end

@implementation DownFileViewController
@synthesize downingTableView,downinglist,headerView;

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
    
    
    downingTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [downingTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [downingTableView setDelegate:self];
    [downingTableView setDataSource:self];
    [self.view addSubview:downingTableView];
    printLog(@"downingTableView=%@",downingTableView);
    
    
    headerView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-downingTableView.frame.size.height, downingTableView.frame.size.width, downingTableView.frame.size.height)];
    [headerView setDelegate:self];
    [downingTableView addSubview:headerView];
    
    
    
    [[FileTranserHelper sharedInstance] setFiletranserDelegate:self];
     self.downinglist=[[[NSMutableArray alloc] init] autorelease];
    
    //加载正在下载的数据列表
    [NSThread detachNewThreadSelector:@selector(loadDowningFiles) toTarget:self withObject:nil];

}

-(void)releaseData
{
    self.downinglist=nil;
    self.downingTableView=nil;
    self.headerView=nil;
}

-(void)dealloc
{
    
    [self releaseData];
    [super dealloc];
}


-(void)viewDidDisappear:(BOOL)animated
{
 [[FileTranserHelper sharedInstance] setFiletranserDelegate:nil];
}
-(void)loadDowningFiles
{
    @autoreleasepool {
        self.downinglist=[[FileTranserHelper sharedInstance] getArchivelist];
        
        if([self.downinglist count]==0)
        {
            printLog(@"self.downinglist is empty");
//            [lblResult performSelectorOnMainThread:@selector(setText:) withObject:NSLocalizedString(@"暂无下载文件", @"") waitUntilDone:YES];
        }
        

        [downingTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        isLoading=NO;
        
        [headerView performSelectorOnMainThread:@selector(egoRefreshScrollViewDataSourceDidFinishedLoading:) withObject:downingTableView waitUntilDone:YES];
    }
    
    
    
}
- (IBAction)AddTask:(id)sender
{
    FileTranserModel *file=[[FileTranserModel alloc] init];
    file.downoadUrl=@"http://union.haolianluo.com/DownloadAction.action?fileName=AiHao_Android(V2.x)_V3.3.3_h00001.apk";
    file.fileName=@"qq.apk";
    file.fileTrueSize=1024;
    [self.downinglist addObject:file];
    [[FileTranserHelper sharedInstance] startDownloadFile:file delegate:nil];
    [file release];
    
    
    [downingTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [downinglist count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        return 74;
    }
    else
    {
        return 84;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"CellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    FileTranserModel *fileModel=[downinglist objectAtIndex:indexPath.row];
    cell.textLabel.text=fileModel.fileName;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"Size:%@ progress:%0f%@",[[FileTranserHelper sharedInstance]getFileSizeString:fileModel.fileTrueSize],fileModel.progress*100,@"%"];
    return cell;
    
//    static NSString *cellIdentifier=@"CellIdentifier_iPhone";
//    DownloadingCell *cell=(DownloadingCell *)[downingTableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if(cell==nil)
//    {
//        cell=[[[DownloadingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
//        [cell.operateButton addTarget:self action:@selector(operateAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    FileTranserModel *fileModel=[downinglist objectAtIndex:indexPath.row];
//    
//    [cell.proView setProgress:fileModel.progress];
//    [cell.fileNameLabel setText:fileModel.fileName];
//    [cell.fileSizeLabel setText:[[FileTranserHelper sharedInstance] getFileSizeString:fileModel.fileTrueSize]];
//    //    [cell.fileImage setImageWithURL:[NSURL URLWithString:fileModel.imgUrl] placeholderImage:[UIImage imageNamed:K_CELL_ICON]];
//    NSDictionary *dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:fileModel,cell,nil] forKeys:[NSArray arrayWithObjects:@"File",@"Cell",nil]];
//    [self updateCellState:dict];
//    return cell;
}


#pragma FileTransferHelper的委托
-(void)fileTranserFail:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel
{
    printLog(@"fileTranserFail");
//    [self updateCurrentDatalist:transerModel];
//    NSDictionary *dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:transerModel,[self getCellByDownURL:transerModel.downoadUrl], nil] forKeys:[NSArray arrayWithObjects:@"File",@"Cell", nil]];
//    [self performSelectorOnMainThread:@selector(updateCellState:) withObject:dict waitUntilDone:YES];
}

-(void)fileTranserStartNewTask:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel
{
    printLog(@"fileTranserStartNewTask");
//    [lblResult performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:YES];
//    UITableViewCell *cell=[self getCellByDownURL:transerModel.downoadUrl];
//    if(cell==nil)
//    {
//        [downinglist addObject:transerModel];
//        [downingTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[downinglist count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//    }
//    NSDictionary *dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:transerModel,[self getCellByDownURL:transerModel.downoadUrl], nil] forKeys:[NSArray arrayWithObjects:@"File",@"Cell", nil]];
//    [self performSelectorOnMainThread:@selector(updateCurrentDatalist:) withObject:transerModel waitUntilDone:YES];
//    [self performSelectorOnMainThread:@selector(updateCellState:) withObject:dict waitUntilDone:YES];
}

-(void)fileTranserCancelTask:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel
{
    printLog(@"fileTranserCancelTask");
//    [self updateCurrentDatalist:transerModel];
//    NSDictionary *dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:transerModel,[self getCellByDownURL:transerModel.downoadUrl], nil] forKeys:[NSArray arrayWithObjects:@"File",@"Cell", nil]];
//    [self performSelectorOnMainThread:@selector(updateCellState:) withObject:dict waitUntilDone:YES];
}

-(void)fileTranserResponse:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel
{
    printLog(@"fileTranserResponse");
    [self updateCurrentDatalist:transerModel];

    [downingTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
//    NSDictionary *dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:transerModel,[self getCellByDownURL:transerModel.downoadUrl], nil] forKeys:[NSArray arrayWithObjects:@"File",@"Cell", nil]];
//    [self performSelectorOnMainThread:@selector(updateCellState:) withObject:dict waitUntilDone:YES];
}

-(void)fileTranserUpdateData:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel
{
    printLog(@"fileTranserUpdateData");
    [self updateCurrentDatalist:transerModel];
    
    [downingTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
//    [self updateCurrentDatalist:transerModel];
//    NSDictionary *dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:transerModel,[self getCellByDownURL:transerModel.downoadUrl], nil] forKeys:[NSArray arrayWithObjects:@"File",@"Cell", nil]];
//    [self performSelectorOnMainThread:@selector(updateCellState:) withObject:dict waitUntilDone:YES];
}

-(void)fileTranserFinished:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel
{
      printLog(@"fileTranserFinished");
//    [NSThread detachNewThreadSelector:@selector(loadDowningFiles) toTarget:self withObject:nil];
}


-(void)updateCurrentDatalist:(FileTranserModel *)newFile
{
    for(FileTranserModel *oldFile in downinglist)
    {
        if([oldFile.downoadUrl isEqualToString:newFile.downoadUrl])
        {
            oldFile.fileTrueSize=newFile.fileTrueSize;
            oldFile.progress=newFile.progress;
            oldFile.remainTime=newFile.remainTime;
            oldFile.fileTranserState=newFile.fileTranserState;
            oldFile.fileTmpSize=newFile.fileTmpSize;
            oldFile.fileTrueSize=newFile.fileTrueSize;
            oldFile.fileTranserState=newFile.fileTranserState;
            oldFile.errorCode=newFile.errorCode;
        }
    }
}


#pragma mark -EGOHeaderDelegate
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return isLoading;
}

-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    isLoading=YES;
    [NSThread detachNewThreadSelector:@selector(loadDowningFiles) toTarget:self withObject:nil];
}


#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [headerView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [headerView egoRefreshScrollViewDidEndDragging:scrollView];
}

@end
