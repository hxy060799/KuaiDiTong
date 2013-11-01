//
//  MainViewController.m
//  KuaiDiTong
//
//  Created by Bill on 13-10-25.
//  Copyright (c) 2013年 Bill. All rights reserved.
//

#import "MainViewController.h"
#import "ResultViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)init{
    if(self=[super init]){
        
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"Result"]){
        ResultViewController *viewController=segue.destinationViewController;
        viewController.resultArray=[NSArray arrayWithArray:(NSArray*)sender];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //self.tableView.backgroundColor=[UIColor redColor];
    
    
    for(int i=0; i < [self.tableView numberOfRowsInSection:0]; i++)
    {
        //UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        //[cell setBackgroundColor:[UIColor blueColor]];
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestFinished:(ASIHTTPRequest *)request{
    
    NSString *responseString=[request responseString];
    
    NSLog(@"%@",responseString);
    
    NSDictionary *jsonDic=[self parseJsonData:[request responseData]];
    
    if(jsonDic!=nil){
        if([[[request userInfo]objectForKey:@"Step"]isEqualToString:@"First"]){
            
            NSArray *comArray=(NSArray*)jsonDic;

            if([comArray count]>0){
                NSDictionary *firstComDic=(NSDictionary*)[comArray objectAtIndex:0];
                NSLog(@"%@",firstComDic);
                NSString *comcode=(NSString*)[firstComDic objectForKey:@"comCode"];
                
                NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kuaidi100.com/query?type=%@&postid=%@&id=1&show=0&muti=0&order=desc",comcode,numberText.text]];
                ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
                [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Second",@"Step",nil]];
                [request setDelegate:self];
                [request startAsynchronous];
            }else{
                [SVProgressHUD showErrorWithStatus:@"单号无效"];
            }
            
        }else if([[[request userInfo]objectForKey:@"Step"]isEqualToString:@"Second"]){
            
            int status=[[jsonDic objectForKey:@"status"]intValue];
            
            NSDictionary *kuaidiDic=[jsonDic objectForKey:@"data"];
            
            if(status==200){
                [SVProgressHUD showSuccessWithStatus:@"成功获取快递数据"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"数据异常"];
            }
            
            [self performSegueWithIdentifier:@"Result" sender:kuaidiDic];
            
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"数据解析失败"];
    }
    
    //[self performSegueWithIdentifier:@"Result" sender:nil];
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    
    [SVProgressHUD showErrorWithStatus:@"无法获取快递数据"];
    
    NSError *error=[request error];
    
    NSLog(@"%@",error.description);
}

-(NSDictionary*)parseJsonData:(NSData*)data{
    
    NSError *error;
    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(json==nil){
        NSLog(@"Failed");
        return nil;
    }
    NSLog(@"%@",json);
    
    return json;
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(indexPath.row){
        case 0:
        {
            [numberText becomeFirstResponder];
            break;
        }
        case 1:
        {
            if([numberText.text isEqual:@""]){
                UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入快递单号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                
                return;
            }
            
            [numberText resignFirstResponder];
            
            [SVProgressHUD showProgress:-1.0f status:@"努力查询中"];
            
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kuaidi100.com/autonumber/auto?num=%@",numberText.text]];
            //NSURL *url=[NSURL URLWithString:@"http://www.baidu.com"];
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
            [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"First",@"Step",nil]];
            [request setDelegate:self];
            [request startAsynchronous];
            break;
        }
        default:
        {
            break;
        }
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
