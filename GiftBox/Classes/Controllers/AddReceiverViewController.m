//
//  AddReceiverViewController.m
//  GiftBox
//
//  Created by sogou on 15/11/9.
//  Copyright © 2015年 sogou. All rights reserved.
//

#import "AddReceiverViewController.h"
#import "MyReceiverTableViewCell.h"

@interface AddReceiverViewController ()

@property (nonatomic, weak)   IBOutlet UIButton*        addBtn;
@property (nonatomic, retain) IBOutlet UITableView*     receiverTableView;
@property (nonatomic, weak)   IBOutlet UILabel*         datePickerLabel;
@property (nonatomic, weak)   IBOutlet UIDatePicker*    datePicker;
@property (strong, nonatomic) IBOutlet UIView*          contentView;
@property (strong, nonatomic) IBOutlet UIView*          mainView;
@property (strong, nonatomic) IBOutlet UIScrollView*    mainScrollView;
@property (nonatomic, assign) NSInteger                 receiverCellHeight;
@property (nonatomic, retain) NSMutableArray*           receivers;
@property (nonatomic, weak)   NSString*                 imageName;
@property (weak, nonatomic) IBOutlet UIImageView*       festivalImageView;

@end

@implementation AddReceiverViewController

@synthesize addBtn;
@synthesize receiverTableView;
@synthesize datePickerLabel;
@synthesize datePicker;
@synthesize contentView;
@synthesize mainScrollView;
@synthesize mainView;
@synthesize receiverCellHeight;
@synthesize imageName;
@synthesize festivalImageView;
@synthesize receivers;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    receiverCellHeight = 45;
    receivers = [[NSMutableArray alloc] initWithCapacity:10];
    [receivers addObject:@"Apple"];
    
    [receiverTableView setDelegate:self];
    [receiverTableView setDataSource:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveData:) name:@"addReceiver" object:nil];
    [self.receiverTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIImage *image = [UIImage imageNamed:imageName];
    [festivalImageView setImage:image];
}

- (void)receiveData:(NSNotification *) notification {
    NSDictionary* userInfo = notification.userInfo;
    NSArray* data = [userInfo objectForKey:@"newReceiver"];
    
    if (data == nil || data.count < 1) {
        return;
    }
    [receivers addObject:data[0]];
    [receiverTableView reloadData];
    
    CGRect newFrame         = receiverTableView.frame;
    newFrame.size           = CGSizeMake(newFrame.size.width,  receiverCellHeight * receivers.count);
    receiverTableView.frame = newFrame;
    
    CGSize contentSize      = mainScrollView.contentSize;
    mainScrollView.contentSize = CGSizeMake(contentSize.width, receiverCellHeight + contentSize.height);
    
    [self adjustViewFrame:addBtn          xoffset:0 yoffset:45];
    [self adjustViewFrame:datePickerLabel xoffset:0 yoffset:45];
    [self adjustViewFrame:datePicker      xoffset:0 yoffset:45];
}

- (void)viewDidAppear:(BOOL)animated {

}

- (void)adjustViewFrame:(UIView*)adjustView xoffset:(NSInteger)x yoffset:(NSInteger)y {
    CGRect newFrame   = adjustView.frame;
    newFrame.origin.x = newFrame.origin.x + x;
    newFrame.origin.y = newFrame.origin.y + y;
    adjustView.frame  = newFrame;
}


- (BOOL)allowsHeaderViewsToFloat{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return receivers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* reuseId = @"Cell";
    MyReceiverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (cell == nil) {
        cell = [[MyReceiverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    NSString* receiver = receivers[indexPath.row];
    cell.textLabel.text = receiver;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"editReceiver"]) {

    }
}

@end
