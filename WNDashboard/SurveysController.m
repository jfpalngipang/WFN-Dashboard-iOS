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
#import "SurveyDetailsController.h"
#import "SurveyDetailsViewController.h"
#import "AppDelegate.h"

@interface SurveysController () 
@end
@implementation SurveysController
{
    NSMutableArray *surveys;
    NSMutableArray *surveyPage;
    NSMutableArray *searchResults;
    NSInteger currentPage;
    NSInteger pageContentCount;
    NSInteger totalPages;
    NSMutableArray *responses;
    NSMutableArray *responseCounts;
    NSArray *responseAPList;
    NSString *ap;
    

    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.spinner.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.spinner];
    [self.spinner startAnimating];
    
    totalPages = 0;
    pageContentCount = 50;
    currentPage = 1;
    surveyPage = [[NSMutableArray alloc] init];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    responseCounts = [[NSMutableArray alloc] init];
    responses = [[NSMutableArray alloc] init];
    [reqUtil GETRequestSender:@"getSurveys" completion:^(NSDictionary* responseDict){
        //NSLog(@"SURVEYS: %@", responseDict);
        for (id survey in responseDict){
            [surveys addObject:survey];
        }
    
        totalPages = (surveys.count / pageContentCount);
        self.totalPageLabel.text = [NSString stringWithFormat:@"%ld", (long)totalPages];
        
        [self setPageTableContent:1];
        [self.spinner stopAnimating];
    }];
    self.totalPageLabel.text = @"14";
    
    self.currentPageLabel.text = @"1";

    surveys = [[NSMutableArray alloc] init];
  
    

    

    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }

}

- (void)setPageTableContent:(NSInteger)page{
    [surveyPage removeAllObjects];
    
    //NSLog(@"%@", surveys);
    if(page == 1){
        
        for (NSInteger i = 0; i < pageContentCount; i++){
            [surveyPage addObject:surveys[i]];
        }
        //NSLog(@"%@", surveyPage);
    } else {
        
        for(NSInteger i = (page-1) * pageContentCount; i < (page * pageContentCount); i++) {
            [surveyPage addObject:surveys[i]];
        }
    }
    
    
    self.tableView.rowHeight = 150;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return surveyPage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *responseCount = [NSString stringWithFormat:@"%@", [[surveyPage objectAtIndex:indexPath.row] objectAtIndex:2]];
    static NSString *identifier = @"Cell";
    SurveysViewCell *cell = (SurveysViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SurveysViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.questionLabel.text = [[surveyPage objectAtIndex:indexPath.row] objectAtIndex:1];
    cell.respLabel.text = responseCount;
    if([[[surveyPage objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"Yes"]){
        cell.activeLabel.text = @"Active";
    } else {
        cell.activeLabel.text = @"Inactive";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [responses removeAllObjects];
    [responseCounts removeAllObjects];
    
    indexPath = [self.tableView indexPathForSelectedRow];

    NSString *surveyId = [[surveys objectAtIndex:indexPath.row] objectAtIndex:0];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    ap = [surveys objectAtIndex:indexPath.row][4];
    [reqUtil GETRequestSender:@"getSurveyDetails" withParams:surveyId completion:^(NSDictionary *responseDict){
        
        for(id resp in responseDict){
            [responses addObject:resp[0]];
            [responseCounts addObject:resp[1]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"showSurveyDetail" sender:self];
        });
    }];
    
    //NSLog(@"%@", [[surveyPage objectAtIndex:indexPath.row] objectAtIndex:1]);
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showSurveyDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%ld", (long)indexPath.row);
        SurveyDetailsController *destViewController = [segue.destinationViewController topViewController];
        destViewController.surveyQuestion = [[surveys objectAtIndex:0] objectAtIndex:1];
        destViewController.responses = responses;
        destViewController.responseCounts = responseCounts;
        responseAPList = [ap componentsSeparatedByString:@","];
        destViewController.responseAPList = responseAPList;
    }
}




- (IBAction)nextClicked:(id)sender {
    currentPage++;
    self.currentPageLabel.text = [NSString stringWithFormat:@"%ld", (long)currentPage];
 
    [self setPageTableContent:currentPage];
}

- (IBAction)prevClicked:(id)sender {
    currentPage--;
    self.currentPageLabel.text = [NSString stringWithFormat:@"%ld", (long)currentPage];
    [self setPageTableContent:currentPage];
}
@end
