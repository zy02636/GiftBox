//
//  MyReceiverTableViewController.m
//  GiftBox
//
//  Created by sogou on 15/11/12.
//  Copyright © 2015年 sogou. All rights reserved.
//

#import "MyReceiverTableViewController.h"
#import "MyReceiverTableViewCell.h"

@interface MyReceiverTableViewController ()

@property (nonatomic, retain) NSDictionary *receivers;
@property (nonatomic, retain) NSArray *receiverSectionTitles;

@end

@implementation MyReceiverTableViewController

@synthesize receivers;
@synthesize receiverSectionTitles;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    receivers = @{@"B" : @[@"Bear", @"Black Swan", @"Buffalo"],
                  @"C" : @[@"Camel", @"Cockatoo"],
                  @"D" : @[@"Dog", @"Donkey"],
                  @"E" : @[@"Emu"],
                  @"G" : @[@"Giraffe", @"Greater Rhea"],
                  @"H" : @[@"Hippopotamus", @"Horse"],
                  @"K" : @[@"Koala"],
                  @"L" : @[@"Lion", @"Llama"],
                  @"M" : @[@"Manatus", @"Meerkat"],
                  @"P" : @[@"Panda", @"Peacock", @"Pig", @"Platypus", @"Polar Bear"],
                  @"R" : @[@"Rhinoceros"],
                  @"S" : @[@"Seagull"],
                  @"T" : @[@"Tasmania Devil"],
                  @"W" : @[@"Whale", @"Whale Shark", @"Wombat"]};
    receiverSectionTitles = [[receivers allKeys] sortedArrayUsingSelector:@selector(localizedCapitalizedString)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return receiverSectionTitles;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [receiverSectionTitles count];
}
                                                                                
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [receiverSectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* sectionTitle     = [receiverSectionTitles objectAtIndex:section];
    NSArray*  sectionReceivers = [receivers objectForKey:sectionTitle];
    return [sectionReceivers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* reuseId = @"Cell";
    MyReceiverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (cell == nil) {
        cell = [[MyReceiverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    NSString *sectionTitle     = [receiverSectionTitles objectAtIndex:indexPath.section];
    NSArray  *sectionReceivers = [receivers objectForKey:sectionTitle];
    NSString *receiver         = [sectionReceivers objectAtIndex:indexPath.row];
    cell.textLabel.text = receiver;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *sectionTitle     = [receiverSectionTitles objectAtIndex:indexPath.section];
    NSArray  *sectionReceivers = [receivers objectForKey:sectionTitle];
    NSString *receiver         = [sectionReceivers objectAtIndex:indexPath.row];

    NSArray* data   = [NSArray arrayWithObjects:receiver, nil];
    
    //添加Notification 传给MyFestivalTableViewController
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:data forKey:@"newReceiver"];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"addReceiver" object:self userInfo:userInfo];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
