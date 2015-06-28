//
//  SidebarViewController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "ViewController.h"
#import "ProfileCell.h"
#import "RevealViewCell.h"
#import "Data.h"
#import "TermsController.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController
{
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    menuItems = @[@"title", @"newsfeed", @"userlogs", @"surveys", @"analytics", @"controlpanel", @"rpm", @"testimonials"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return menuItems.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    indexPath = [tableView indexPathForSelectedRow];
    if(indexPath.row == 0){
        UIActionSheet *logoutSheet = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Profile", @"Terms and Agreement", @"Log Out",nil];
        [logoutSheet showInView:self.view];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //UIButton *logoutButton = (UIButton *)[cell viewWithTag:100];
    //[logoutButton addTarget:self action:@selector(logoutClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *username = (UILabel *)[cell viewWithTag:101];
    username.text = user;
    return cell;
    
    /*
    if(indexPath.row == 0){
        static NSString *identifier = @"Cell";
        RevealViewCell *cell = (RevealViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RevealViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.viewLabel.text = user;
        cell.viewLabel.textColor = [UIColor orangeColor];
        cell.logoutButton.tag = 100;
        [cell.logoutButton addTarget:self action:@selector(logoutClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        static NSString *identifier = @"Cell";
        RevealViewCell *cell = (RevealViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RevealViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.viewLabel.text = [menuItems objectAtIndex:indexPath.row-1];
        cell.logoutButton.hidden = true;
        return cell;
    }
*/
    
    
}

-(void)logoutClicked:(UIButton*)sender
{
    if (sender.tag == 100)
    {
        UIActionSheet *logoutSheet = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Account Settings", @"Terms and Agreement", @"Log Out",nil];
        [logoutSheet showInView:self.view];
        
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"Account Settings"]){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             [self performSegueWithIdentifier:@"showProfile" sender:self];
         }];
    } else if ([buttonTitle isEqualToString:@"Terms and Agreement"]){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             [self performSegueWithIdentifier:@"showTerms" sender:self];
         }];

    } else if ([buttonTitle isEqualToString:@"Log Out"]){
        
    }
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
