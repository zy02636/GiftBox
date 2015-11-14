//
//  UserCenterViewController.m
//  GiftBox
//
//  Created by sogou on 15/11/10.
//  Copyright © 2015年 sogou. All rights reserved.
//

#import "UserCenterViewController.h"

@interface UserCenterViewController ()

@property (nonatomic, retain) IBOutlet UIImageView* headImgView;
@property (nonatomic, retain) IBOutlet UITableView* receTableView;

@end

@implementation UserCenterViewController

@synthesize headImgView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    headImgView.frame = CGRectMake(20.f, 20.f, 100.f, 100.f);
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = 45;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
