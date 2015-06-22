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

@interface SurveysController () <UISearchBarDelegate, UISearchResultsUpdating>
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults;

@end
@implementation SurveysController
{
    NSMutableArray *surveys;
    NSMutableArray *surveyPage;
    NSMutableArray *searchResults;
    NSInteger currentPage;
    NSInteger pageContentCount;
    NSInteger totalPages;
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    totalPages = 0;
    pageContentCount = 50;
    currentPage = 1;
    surveyPage = [[NSMutableArray alloc] init];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    
    [reqUtil GETRequestSender:@"getSurveys" completion:^(NSDictionary* responseDict){
        //NSLog(@"SURVEYS: %@", responseDict);
        for (id survey in responseDict){
            [surveys addObject:survey];
        }
        totalPages = (surveys.count / pageContentCount);
        self.totalPageLabel.text = [NSString stringWithFormat:@"%ld", (long)totalPages];
        
        [self setPageTableContent:1];
    }];
    self.totalPageLabel.text = @"14";
    
    self.currentPageLabel.text = @"1";

    surveys = [[NSMutableArray alloc] init];
  
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[surveys count]];
    

    
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
    cell.apLabel.text = [[surveyPage objectAtIndex:indexPath.row] objectAtIndex:4];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //indexPath = [self.tableView indexPathForSelectedRow];
    [self performSegueWithIdentifier:@"showSurveyDetail" sender:self];
    //NSLog(@"%@", [[surveyPage objectAtIndex:indexPath.row] objectAtIndex:1]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showSurveyDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%ld", (long)indexPath.row);
        SurveyDetailsController *destViewController = [segue.destinationViewController topViewController];
        destViewController.surveyQuestion = [[surveys objectAtIndex:0] objectAtIndex:1];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSString *scope = nil;
    
    NSInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];
    if (selectedScopeButtonIndex > 0) {
        scope = [surveys objectAtIndex:(selectedScopeButtonIndex - 1)];
    }
    //[self updateFilteredContentForProductName:searchString type:scope];
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
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
