//
//  SurveysController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "SurveysController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"
#import "SurveysViewCell.h"

@implementation SurveysController
{
    NSMutableArray *surveys;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    surveys = [[NSMutableArray alloc] init];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil GETRequestSender:@"getSurveys" completion:^(NSDictionary* responseDict){
        //NSLog(@"SURVEYS: %@", responseDict);
        for (id survey in responseDict){
            [surveys addObject:survey];
        }
        NSLog(@"%@", surveys[0][1]);
        self.tableView.rowHeight = 120;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    }];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return surveys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *responseCount = [NSString stringWithFormat:@"%@", [[surveys objectAtIndex:indexPath.row] objectAtIndex:2]];
    static NSString *identifier = @"Cell";
    SurveysViewCell *cell = (SurveysViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SurveysViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.questionLabel.text = [[surveys objectAtIndex:indexPath.row] objectAtIndex:1];
    cell.respLabel.text = responseCount;
    cell.apLabel.text = [[surveys objectAtIndex:indexPath.row] objectAtIndex:4];
    return cell;
}


@end
