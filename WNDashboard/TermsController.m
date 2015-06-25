//
//  TermsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/18/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "TermsController.h"
#import "SWRevealViewController.h"

@interface TermsController ()

@end

@implementation TermsController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"Title";
    self.navigationItem.backBarButtonItem = item;
    
    self.webView.frame=self.view.bounds;
    NSString *strURL = @"http://dev.wifination.ph:3000/mobile/terms/";
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    self.webView.scalesPageToFit = YES;
    /*
    UIStoryboard *st = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SWRevealViewController *revealViewController = [st instantiateViewControllerWithIdentifier:@"revealView"];
    //[self presentViewController:revealViewController animated:YES completion:nil]
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
     */
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
