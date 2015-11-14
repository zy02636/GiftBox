//
//  AddFestivalTableViewController.m
//  GiftBox
//
//  Created by sogou on 15/11/10.
//  Copyright © 2015年 sogou. All rights reserved.
//

#import "AddFestivalTableViewController.h"
#import "MyFestivalTableViewController.h"
#import "MyFestivalTableViewCell.h"

@interface AddFestivalTableViewController ()

@property (nonatomic, retain) NSMutableDictionary* festivalDict;
@property (nonatomic, assign) CGFloat   imgRatio;
@property (nonatomic, assign) NSInteger imgWidth;
@property (nonatomic, assign) NSInteger imgHeight;
@property (nonatomic, assign) NSInteger rowHeight;
@property (nonatomic, assign) NSInteger cellPadding;

@end

@implementation AddFestivalTableViewController

@synthesize festivalDict;
@synthesize imgRatio;
@synthesize imgWidth;
@synthesize imgHeight;
@synthesize rowHeight;
@synthesize cellPadding;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    festivalDict = [[NSMutableDictionary alloc] initWithCapacity:20];
    [festivalDict setObject:@"WanShengJie.jpg"forKey:@"万圣节"];
    [festivalDict setObject:@"ZhongQiu.jpg"   forKey:@"中秋节"];
    [festivalDict setObject:@"YuanXiao.jpg"   forKey:@"元宵节"];
    [festivalDict setObject:@"ShengDan.jpg"   forKey:@"圣诞节"];
    [festivalDict setObject:@"GanEN.jpg"      forKey:@"感恩节"];
    
    CGRect screenBounds = [[ UIScreen mainScreen ] bounds];
    NSInteger screenWidth  = screenBounds.size.width;
    NSInteger screenHeight = screenBounds.size.height;
    
    // 1136 * 640   2208* 1242
    imgRatio    = 30.0/11.0;
    cellPadding = 10;
    imgWidth    = screenWidth - cellPadding * 2;
    imgHeight   = (NSInteger)imgWidth/imgRatio;
    rowHeight   = imgHeight + 40;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveData:) name:@"newFestival" object:nil];
}

- (void)receiveData:(NSNotification *) notification {
    NSDictionary* userInfo = notification.userInfo;
    NSArray* data = [userInfo objectForKey:@"newFestival"];
    
    if (data == nil || data.count < 3) {
        return;
    }
    //先用默认吧
    [festivalDict setObject:@"JiaoShi.jpg" forKey:data[0]];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addFestival:(id)sender
{
    [self performSegueWithIdentifier:@"SendValue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return festivalDict.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* resuseId = @"reuseCell";
    MyFestivalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseId];
    
    if (cell == nil) {
        cell = [[MyFestivalTableViewCell alloc] initWithReuseIdentifier:resuseId];
    }
    
    NSArray* keys = [festivalDict allKeys];
    UIImage* image = [UIImage imageNamed:[festivalDict objectForKey:keys[[indexPath row]]]];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(cellPadding, cellPadding, imgWidth, imgHeight)];
    [imgView setImage:image];
    
    
    UILabel* lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, rowHeight - 25, 80, 30)];
    lblName.text = keys[[indexPath row]];
    [lblName setTextColor:[UIColor grayColor]];
    [lblName setFont:[UIFont systemFontOfSize:13]];
    
    UILabel* lblDate = [[UILabel alloc] initWithFrame:CGRectMake(80, rowHeight - 25, 120, 30)];
    lblDate.text = @"2015-12-25";
    [lblDate setTextColor:[UIColor grayColor]];
    [lblDate setFont:[UIFont systemFontOfSize:13]];
    
    [cell.contentView addSubview:imgView];
    [cell.contentView addSubview:lblName];
    [cell.contentView addSubview:lblDate];
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    NSLog(@"width:%f, height:%f", imgView.bounds.size.width, imgView.bounds.size.height);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    NSArray* keys   = [festivalDict allKeys];
    NSString* key   = keys[[indexPath row]];
    NSString* value = [festivalDict objectForKey:key];
    NSArray* data   = [NSArray arrayWithObjects:key, value, nil];
    
    //添加Notification 传给MyFestivalTableViewController
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:data forKey:@"addedFes"];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"addFestival" object:self userInfo:userInfo];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray* keys       = [festivalDict allKeys];
        NSString* removeKey = keys[[indexPath row]];
        [festivalDict removeObjectForKey:removeKey];

        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SendValue"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        MyFestivalTableViewController *receiver = segue.destinationViewController;
        receiver.festivalName = @"元旦!";
    }
}*/


@end
