//
//  SurveyAPViewController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/19/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "SurveyAPViewController.h"
#import "SurveyDetailsController.h"
#import "SurveyAPCell.h"

@interface SurveyAPViewController ()

@end

@implementation SurveyAPViewController
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController *parent = self.parentViewController;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    NSLog(@"^^^^^^^^^PARENT^^^^^^^^^: %@", parent);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UIViewController *parent = self.parentViewController;
    NSLog(@"FFFFFFFFFFFFFFFFF%d", ((SurveyDetailsController *)parent).responseAPList.count);
    return ((SurveyDetailsController *)parent).responseAPList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *parent = self.parentViewController;
    NSString *branchUnparsed = [((SurveyDetailsController *)parent).responseAPList objectAtIndex:indexPath.row];
    NSArray *branchArr = [branchUnparsed componentsSeparatedByString:@" - "];
    NSString *branch = [NSString stringWithFormat:@"%@", [branchArr objectAtIndex:1]];
    
    static NSString *identifier = @"Cell";
    SurveyAPCell *cell = (SurveyAPCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SurveyAPCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.branchLabel.text= branch;
    return cell;
    
}

- (void) refreshTable {
    
    UIViewController *parent = self.parentViewController;
    //NSLog(@"FFFFFFFFFFFFFFFFF%@", ((SurveyDetailsController *)parent).responseAPList);
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
