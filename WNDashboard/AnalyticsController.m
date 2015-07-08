//
//  AnalyticsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "AnalyticsController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"
#import "DateSelectionController.h"
#import "Data.h"
#import "AgeGenderController.h"
#import "ConnectedUsersController.h"

@implementation AnalyticsController
{
    NSString *rangeDate;
    NSString *selected_apId;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    self.connectedusersContainer.hidden = false;
    self.agegenderContainer.hidden = true;
    
    self.dateTextField.delegate = self;
    self.apTextField.delegate = self;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == self.dateTextField){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DateSelectionController *selectModal = [storyboard instantiateViewControllerWithIdentifier:@"DateSelectionController"];
        selectModal.selectMode = @"range";
        selectModal.myDelegate = self;
        [selectModal setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:selectModal animated:YES completion:nil];
    } else if(textField == self.apTextField){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DateSelectionController *selectModal = [storyboard instantiateViewControllerWithIdentifier:@"DateSelectionController"];
        selectModal.selectMode = @"ap";
        selectModal.myDelegate = self;
        [selectModal setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:selectModal animated:YES completion:nil];
    }

    return NO;
}

- (void)modalViewDismissed:(NSString *)value withSelectMode:(NSString *)mode{
    if([mode isEqualToString:@"range"]){
        self.dateTextField.text = value;
        if([value isEqualToString:@"Today"]){
            rangeDate = [NSString stringWithFormat:@"%@-%@",today,today];
        }else if([value isEqualToString:@"Last 7 Days Ago"]){
            NSDate *dateToday = [NSDate date];
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setDay:-1];
            NSDate *yesterdate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dateToday options:0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yy"];
            NSString *yesterday = [dateFormatter stringFromDate:yesterdate];
            rangeDate = [NSString stringWithFormat:@"%@-%@",yesterday,yesterday];
        } else if([value isEqualToString:@"30 Days Ago"]){
            NSDate *dateToday = [NSDate date];
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setDay:-29];
            NSDate *datesAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dateToday options:0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yy"];
            NSString *daysAgo = [dateFormatter stringFromDate:datesAgo];
            rangeDate = [NSString stringWithFormat:@"%@-%@",daysAgo,daysAgo];
        }
        
        
    }else if([mode isEqualToString:@"ap"]){
        self.apTextField.text = value;
        NSUInteger selected_index = [apNames indexOfObject:value];
        selected_apId = [Data getIdForAPAtIndex:selected_index];
    }
}
- (IBAction)segmentChanged:(id)sender {
    switch (self.segmentControl.selectedSegmentIndex){
        case 0:
            self.connectedusersContainer.hidden = false;
            self.agegenderContainer.hidden = true;
            break;
        case 1:
            self.connectedusersContainer.hidden = true;
            self.agegenderContainer.hidden = false;
            break;
        default:
            break;
    }
}
- (IBAction)goClicked:(id)sender {
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil getAnalyticsFor:selected_apId withRange:rangeDate completion:^(NSDictionary *responseDict){
        ConnectedUsersController *cuC = [self.childViewControllers objectAtIndex:0];
        AgeGenderController *agC = [self.childViewControllers objectAtIndex:1];
        
        cuC.a = responseDict[@"active"];
        agC.f = responseDict[@"agegender"][@"f"];
        agC.m = responseDict[@"agegender"][@"m"];
        agC.o = responseDict[@"agegender"][@"o"];
        
        //NSLog(@"RESPONSE: %@", responseDict);
        [cuC beginCharting];
        [agC beginCharting];
    }];
}
@end
