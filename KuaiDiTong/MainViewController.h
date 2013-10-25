//
//  MainViewController.h
//  KuaiDiTong
//
//  Created by Bill on 13-10-25.
//  Copyright (c) 2013年 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SVProgressHUD.h"
#import "ASIHTTPRequest.h"

@interface MainViewController : UITableViewController<ASIHTTPRequestDelegate>{
    IBOutlet UITextField* numberText;
}

@end
