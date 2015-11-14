//
//  MyFestivalTableViewController.m
//  GiftBox
//
//  Created by sogou on 15/11/10.
//  Copyright © 2015年 sogou. All rights reserved.
//

#import "MyFestivalTableViewController.h"
#import "MyFestivalTableViewCell.h"
#import "FestivalModel.h"

@interface MyFestivalTableViewController ()

@property (nonatomic, retain) NSMutableDictionary* festivalDict;
@property (nonatomic, assign) CGFloat              imgRatio;
@property (nonatomic, assign) NSInteger            imgWidth;
@property (nonatomic, assign) NSInteger            imgHeight;
@property (nonatomic, assign) NSInteger            rowHeight;
@property (nonatomic, assign) NSInteger            cellPadding;
@property (nonatomic, retain) FestivalModel*       festivalModel;
@property (nonatomic, assign) BOOL                 dataLoaded;
@property (nonatomic, assign) NSArray*             allfestival;

@end

@implementation MyFestivalTableViewController

@synthesize festivalDict;
@synthesize imgRatio;
@synthesize imgWidth;
@synthesize imgHeight;
@synthesize rowHeight;
@synthesize cellPadding;
@synthesize allfestival;
@synthesize festivalModel;
@synthesize dataLoaded;

- (void)viewDidLoad {
    [super viewDidLoad];
    dataLoaded = false;
    
    festivalDict = [[NSMutableDictionary alloc] initWithCapacity:20];
    [festivalDict setObject:@"ChunJie.jpg"     forKey:@"春节"];
    [festivalDict setObject:@"ChuXi.jpg"       forKey:@"除夕"];
    [festivalDict setObject:@"DuanWu.jpg"      forKey:@"端午"];
    [festivalDict setObject:@"ErTongJie.jpg"   forKey:@"儿童节"];
    [festivalDict setObject:@"FuHuo.jpg"       forKey:@"复活节"];
    [festivalDict setObject:@"FuNv.jpg"        forKey:@"妇女节"];
    [festivalDict setObject:@"MuQinJie.jpg"    forKey:@"母亲节"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveData:) name:@"addFestival" object:nil];
    
    CGRect screenBounds = [[ UIScreen mainScreen ] bounds];
    NSInteger screenWidth  = screenBounds.size.width;
    NSInteger screenHeight = screenBounds.size.height;
    
    // 1136 * 640   2208* 1242
    imgRatio    = 30.0/11.0;
    cellPadding = 10;
    imgWidth    = screenWidth - cellPadding * 2;
    imgHeight   = (NSInteger)imgWidth/imgRatio;
    rowHeight   = imgHeight + 40;
    NSLog(@"imgWidth:%ld, imgHeight:%ld, rowHeight:%ld", imgWidth, imgHeight, (long)rowHeight);
    
    
    //added by zhangjian
    //获取uuid
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    static NSString* UUID_KEY = @"MPUUID";
    NSString* app_uuid = [userDefaults stringForKey:UUID_KEY];
    if (app_uuid == nil) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        app_uuid = [NSString stringWithString:(__bridge NSString*)uuidString];
        [userDefaults setObject:app_uuid forKey:UUID_KEY];
        [userDefaults synchronize];
        CFRelease(uuidString);
        CFRelease(uuidRef);
    }
    
    
    // 1.创建请求
    NSURL *url = [NSURL URLWithString:@"http://10.144.96.54/festival"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"uid" : app_uuid,
                           @"op" : @"show",
                           @"type" : @"0"
                           };
    
    //NSDictionary --> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:data];
    
    //异步请求
    NSURLSession* session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    if (!error && httpResponse.statusCode >= 200 && httpResponse.statusCode <300) {
                        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        allfestival = [dic objectForKey:@"festival_list"];
                        dataLoaded = true;
                        [self.tableView reloadData];
                        NSLog(@"size:%ld", allfestival.count);
                    }
                }] resume];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)receiveData:(NSNotification *) notification {
    NSDictionary* userInfo = notification.userInfo;
    NSArray* data = [userInfo objectForKey:@"addedFes"];
    
    if (data == nil || data.count < 2) {
        return;
    }
    [festivalDict setObject:data[1] forKey:data[0]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.tag = [indexPath row];
    } else {
        if ([indexPath row] == allfestival.count) {
            NSArray *viewsToRemove = [cell.contentView subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
        }
    }
    
    //NSURL *url = [NSURL URLWithString:[allfestival[indexPath.row] objectForKey:@"pic"]];
    //NSURL *url = [NSURL URLWithString:[festivalModel[indexPath.row] objectForKey:@"pic"]];
    //UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    NSArray* keys = [festivalDict allKeys];
    NSString* key = keys[indexPath.row];
    NSString* name = festivalDict[key];
    UIImage *image=[UIImage imageNamed:name];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(cellPadding, cellPadding, imgWidth, imgHeight)];
    [imgView setImage:image];
    
    
    UILabel* lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, rowHeight - 25, 80, 30)];
    lblName.text = [allfestival[indexPath.row] objectForKey:@"name"];
    [lblName setTextColor:[UIColor grayColor]];
    [lblName setFont:[UIFont systemFontOfSize:13]];
    
    UILabel* lblDate = [[UILabel alloc] initWithFrame:CGRectMake(80, rowHeight - 25, 120, 30)];
    lblDate.text = [allfestival[indexPath.row] objectForKey:@"date"];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"editReceiver"]){
        id theSegue = segue.destinationViewController;
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        
        NSArray* keys = [festivalDict allKeys];
        NSString* key = keys[indexPath.row];
        NSString* name = festivalDict[key];
        [theSegue setValue:name forKey:@"imageName"];
    }
}


@end
