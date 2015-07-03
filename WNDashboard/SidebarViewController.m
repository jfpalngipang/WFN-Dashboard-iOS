//
//  SidebarViewController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//
//  controller for the slide-out menu. It uses SWRevealViewController by John-Lluch (https://github.com/John-Lluch/SWRevealViewController)

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
        UIActionSheet *logoutSheet = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Account Settings", @"Terms and Agreement", @"Log Out",nil];
        [logoutSheet showInView:self.view];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    UILabel *username = (UILabel *)[cell viewWithTag:101];
    username.text = user;
    return cell;
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
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasSuccessfullySignedInBefore"];
             [self performSegueWithIdentifier:@"backToLogin" sender:self];
         }];
        
    }
}

@end
