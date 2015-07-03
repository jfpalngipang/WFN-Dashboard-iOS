//
//  DateSelectionController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/29/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol modalDelegate <NSObject>
- (void) modalViewDismissed:(NSString *)value withSelectMode:(NSString *)mode;
@end
@interface DateSelectionController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSString *mode;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *apPicker;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
- (IBAction)doneButton:(id)sender;
- (IBAction)dateSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *rangePicker;

@property (weak, nonatomic) NSString *selectMode;
@property (weak, nonatomic) NSString *selectedRange;
@property (weak, nonatomic) NSString *selectedAP;
@property (strong, nonatomic) NSString *formatedDate;
@property (weak, nonatomic) NSString *selectedDate;
@property (nonatomic, assign) id<modalDelegate> myDelegate;
@end
