//
//  UserLogsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/10/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "UserLogsController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"
#import "DownPicker.h"


@interface UserLogsController () {
    NSMutableArray *_ap_list;
}

@end

@implementation UserLogsController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ap_list = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil GETRequestSender:@"getAPList" completion:^(NSDictionary* responseDict){
        
        for(id ap in responseDict){
            [_ap_list addObject:ap[1]];
        }
        NSLog(@"Picker Items: %@", _ap_list);
            self.downPicker = [[DownPicker alloc] initWithTextField:self.APListTextField withData:_ap_list];

    }];
    
    

    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
      
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _ap_list.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _ap_list[row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)APSelectClicked:(id)sender {
   /*
    [ActionSheetStringPicker showPickerWithTitle:@"Access Points" rows:_ap_list initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue){
        NSLog(@"%@", selectedValue);
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Cancelled");
        
    } origin:sender];
     */
}
@end
