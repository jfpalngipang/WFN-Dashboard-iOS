//
//  DateSelectionController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/29/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//
//  Picker/DatePicker utility for the app

#import "DateSelectionController.h"
#import "Data.h"

@interface DateSelectionController ()

@end

@implementation DateSelectionController
{
    NSArray *range;
}
@synthesize selectMode;
@synthesize selectedAP;
@synthesize selectedDate;
@synthesize myDelegate;
@synthesize formatedDate;
@synthesize selectedRange;




- (void)viewDidLoad {
    [super viewDidLoad];
    range = [[NSArray alloc] initWithObjects:@"Today",@"Last 7 Days", @"30 Days Ago", nil];
    formatedDate = [[NSString alloc] init];
    // Do any additional setup after loading the view.
    if([selectMode isEqualToString:@"date"]){
        self.selectLabel.text = @"Select Date";
        self.datePicker.hidden = false;
        self.apPicker.hidden = true;
        self.rangePicker.hidden = true;
    } else if([selectMode isEqualToString:@"ap"]){
        self.selectLabel.text = @"Select Access Point";
        self.datePicker.hidden = true;
        self.apPicker.hidden = false;
        self.rangePicker.hidden = true;
    } else if([selectMode isEqualToString:@"range"]){
        self.selectLabel.text = @"Select Date";
        self.datePicker.hidden = true;
        self.apPicker.hidden = true;
        self.rangePicker.hidden = false;
    }
    [self.datePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    [self.datePicker addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.apPicker.dataSource = self;
    self.apPicker.delegate = self;
    self.rangePicker.dataSource = self;
    self.rangePicker.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == self.apPicker){
        return apNames.count;
    } else{
        return range.count;
    }
    
}

// The data to return for the row and component (column) that's being passed in
- (NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == self.apPicker){
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:apNames[row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    } else{
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:range[row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == self.apPicker){
        selectedAP = [apNames objectAtIndex:row];
    }else {
        selectedRange = [range objectAtIndex:row];
    }
    
}
- (IBAction)doneButton:(id)sender {
    if([selectMode isEqualToString:@"date"]){
        if([formatedDate length] == 0) {
            formatedDate = today;
        }
        [self.myDelegate modalViewDismissed:self.formatedDate withSelectMode:@"date"];
        //NSLog(@"CHOSEN DATE: %@", formatedDate);
    } else if([selectMode isEqualToString:@"ap"]){
        if([selectedAP length] == 0){
            selectedAP = apNames[0];
        }
        [self.myDelegate modalViewDismissed:selectedAP withSelectMode:@"ap"];
    }else if([selectMode isEqualToString:@"range"]){
        if([selectedRange length] == 0){
            selectedRange = @"Today";
        }
        [self.myDelegate modalViewDismissed:selectedRange withSelectMode:@"range"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dateSelected:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    self.formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    //NSLog(@"%@", formatedDate);
    
}
@end
