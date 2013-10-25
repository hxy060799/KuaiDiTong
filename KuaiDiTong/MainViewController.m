//
//  MainViewController.m
//  KuaiDiTong
//
//  Created by Bill on 13-10-25.
//  Copyright (c) 2013年 Bill. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)init{
    if(self=[super init]){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
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
    
    [SVProgressHUD showSuccessWithStatus:@"成功获取快递数据"];
    
    NSString *responseString=[request responseString];
    
    NSLog(@"%@",responseString);

    [self performSegueWithIdentifier:@"Result" sender:nil];
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    
    [SVProgressHUD showSuccessWithStatus:@"无法获取快递数据"];
    
    NSError *error=[request error];
    
    NSLog(@"%@",error.description);
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==1){
        if([numberText.text isEqual:@""]){
            UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入快递单号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
        
        [SVProgressHUD showProgress:-1.0f status:@"努力查询中"];
        
        NSURL *url=[NSURL URLWithString:@"http://www.baidu.com"];
        ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
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
