//
//  UserProfileController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/25/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "UserProfileController.h"
#import "SWRevealViewController.h"
#import "Data.h"
#import "requestUtility.h"


@interface UserProfileController ()

@end

@implementation UserProfileController
{
    NSMutableArray *profileData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.disableView.hidden = false;
    self.activityIndicatorContainer.hidden = false;
    
    profileData = [[NSMutableArray alloc] init];
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    //self.locationTextView.layer.borderWidth = 1.0f;
    //self.locationTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil getData:@"userprofile" completion:^(NSDictionary *profile){
        //NSLog(@"USER PROFILE: %@", profile);
        for(id data in profile){
            [profileData addObject:data];
        }
        //dispatch_async(dispatch_get_main_queue(), ^{

            self.emailTextField.text = profileData[0];
            self.firstTextField.text = profileData[1];
            self.lastTextField.text = [NSString stringWithFormat:@"%@", profileData[2]];
            self.contactTextField.text = profileData[3];
            self.locationTextField.text = profileData[4];
            
        //});
        self.disableView.hidden = true;
        self.activityIndicatorContainer.hidden = true;
    }];
    

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

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)updateClicked:(id)sender {
}
@end
