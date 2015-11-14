//
//  AddFestivalViewController.m
//  GiftBox
//
//  Created by sogou on 15/11/10.
//  Copyright © 2015年 sogou. All rights reserved.
//

#import "AddFestivalViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface AddFestivalViewController ()

@property (nonatomic, retain) IBOutlet UIButton*     saveBtn;
@property (nonatomic, retain) IBOutlet UITextField*  fesNameField;
@property (nonatomic, retain) IBOutlet UITextView*   fesDetaField;
@property (nonatomic, retain) IBOutlet UIDatePicker* fesDate;
@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView* scrollView;

@end

@implementation AddFestivalViewController

@synthesize saveBtn;
@synthesize fesDetaField;
@synthesize fesNameField;
@synthesize fesDate;
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(hideKeyboard:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
    
    UISwipeGestureRecognizer* swapDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [swapDownGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    
    swapDownGesture.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:swapDownGesture];
    
    UISwipeGestureRecognizer* swapUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [swapDownGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    
    swapDownGesture.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:swapUpGesture];
    
    fesDetaField.layer.borderColor = [UIColor grayColor].CGColor;
    fesDetaField.layer.borderWidth = 1.0;
    fesDetaField.layer.cornerRadius= 5.0;
    
    
    saveBtn.layer.borderColor      = [UIColor grayColor].CGColor;
    saveBtn.layer.borderWidth      = 1.0;
    saveBtn.layer.cornerRadius     = 5.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveAndClose:(id)sender {
    NSString* festivalName   = fesNameField.text;
    NSString* festivalDetail = fesDetaField.text;
    NSString* festivalDate   = [fesDate.date description];
    
    NSArray* data   = [NSArray arrayWithObjects:festivalName, festivalDetail, festivalDate, nil];
    
    //添加Notification 传给MyFestivalTableViewController
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:data forKey:@"newFestival"];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"newFestival" object:self userInfo:userInfo];
    
    NSLog(@"Passing:%@, %@, %@", festivalName, festivalDetail, festivalDate);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hideKeyboard:(id)sender {
    [fesNameField resignFirstResponder];
    [fesDetaField resignFirstResponder];
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
