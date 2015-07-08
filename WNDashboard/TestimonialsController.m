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

@interface TestimonialsController () <SWRevealViewControllerDelegate, SWTableViewCellDelegate>


@property (strong, nonatomic) MessageCell *messageCell;
@end
@implementation TestimonialsController
{
    NSMutableArray *messages;
    BOOL sidebarMenuOpen;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.disableView.hidden = false;
    self.activityIndicatorContainer.hidden = false;
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
    
    [reqUtil getData:@"messages" completion:^(NSDictionary *responseDict){
        //NSLog(@"Messages: %@", responseDict);
        for (id message in responseDict){
            [messages addObject:message];
        }

        self.tableView.allowsSelection = NO;
        NSLog(@"%@", messages);
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
        self.disableView.hidden = true;
        self.activityIndicatorContainer.hidden = true;
    }];
    self.revealViewController.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    /*
    //Calculate height based on cell
    if(!self.messageCell){
        self.messageCell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    }
    
    //Configure the cell
    NSString *name = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:1]];
    NSString *estab = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:0]];
    NSString *time = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:3]];
    NSString *testimonial = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:4]];
    NSString *fbId = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:2]];

    //self.messageCell.delegate = self;
    FBSDKProfilePictureView *profilePicture = [[FBSDKProfilePictureView alloc] initWithFrame:self.messageCell.userImage.frame];
    
    [profilePicture setProfileID:fbId];
    profilePicture.layer.borderWidth = 0;
    [self.messageCell addSubview:profilePicture];
    self.messageCell.nameLabel.text = name;
    self.messageCell.estabLabel.text = estab;
    self.messageCell.timeLabel.text = time;
    self.messageCell.testimonialLabel.text = testimonial;
    
    //self.messageCell.rightUtilityButtons = [self rightButtons];
    
    //Layout the cell
    [self.messageCell layoutIfNeeded];
    
    //Get height
    CGFloat height = [self.messageCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height;
    
    */

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
    //cell.delegate = self;
    FBSDKProfilePictureView *profilePicture = [[FBSDKProfilePictureView alloc] initWithFrame:cell.userImage.frame];
    
    [profilePicture setProfileID:fbId];
    profilePicture.layer.borderWidth = 0;
    [cell addSubview:profilePicture];
    
    cell.nameLabel.text = name;
    cell.estabLabel.text = estab;
    cell.timeLabel.text = time;
    cell.testimonialLabel.text = testimonial;
    
    //cell.rightUtilityButtons = [self rightButtons];

    return cell;
    
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor orangeColor] title:@"Reply"];
    
    return rightUtilityButtons;
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    
    if(position == FrontViewPositionLeft) {
        self.tableView.userInteractionEnabled = YES;
        sidebarMenuOpen = NO;
    } else {
        self.tableView.userInteractionEnabled = NO;
        sidebarMenuOpen = YES;
        NSLog(@"MENU OPEN!");
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.tableView.userInteractionEnabled = YES;
        sidebarMenuOpen = NO;
    } else {
        self.tableView.userInteractionEnabled = NO;
        sidebarMenuOpen = YES;
         NSLog(@"MENU OPEN!");
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
