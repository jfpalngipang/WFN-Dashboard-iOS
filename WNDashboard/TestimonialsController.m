//
//  TestimonialsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/15/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "TestimonialsController.h"
#import "SWRevealViewController.h"
#import "requestUtility.h"
#import "MessageCell.h"
#import "SWTableViewCell.h"
#import <FBSDKCoreKit/FBSDKProfilePictureView.h>

@interface TestimonialsController ()

@end

@implementation TestimonialsController
{
    NSMutableArray *messages;
    BOOL sidebarMenuOpen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sidebarMenuOpen = NO;
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    messages = [[NSMutableArray alloc] init];
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil GETRequestSender:@"getMessages" completion:^(NSDictionary *responseDict){
        //NSLog(@"Messages: %@", responseDict);
        for (id message in responseDict){
            [messages addObject:message];
        }
        //self.tableView.rowHeight = 300;
        //[setSelectionStyle:UITableViewCellSelectionStyleNone];
        //[cell setUserInteractionEnabled:NO];
        self.tableView.allowsSelection = NO;
        NSLog(@"%@", messages);
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }];
    
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 4){
        return 300;
    } else {
        return 150;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messages.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:1]];
    NSString *estab = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:0]];
    NSString *time = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:3]];
    NSString *testimonial = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:4]];
    NSString *fbId = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:2]];
    static NSString *identifier = @"Cell";
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];

    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.delegate = self;
    FBSDKProfilePictureView *profilePicture = [[FBSDKProfilePictureView alloc] initWithFrame:cell.userImage.frame];
    
    [profilePicture setProfileID:fbId];
    profilePicture.layer.borderWidth = 0;
    [cell addSubview:profilePicture];
    cell.nameLabel.text = name;
    cell.estabLabel.text = estab;
    cell.timeLabel.text = time;
    cell.testimonialLabel.text = testimonial;
    return cell;
    
}


- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
        sidebarMenuOpen = NO;
    } else {
        self.view.userInteractionEnabled = NO;
        sidebarMenuOpen = YES;
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
        sidebarMenuOpen = NO;
    } else {
        self.view.userInteractionEnabled = NO;
        sidebarMenuOpen = YES;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(sidebarMenuOpen == YES){
        return nil;
    } else {
        return indexPath;
    }
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
