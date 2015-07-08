//
//  SurveysController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "SurveysController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"
#import "SurveysViewCell.h"
#import "SurveyDetailsController.h"
#import "SurveyDetailsViewController.h"
#import "AppDelegate.h"
#import "Data.h"

@interface SurveysController () <UISearchBarDelegate, SWRevealViewControllerDelegate>
@end
@implementation SurveysController
{
    NSMutableArray *surveys;
    NSMutableArray *temp;
    NSArray *page;
    NSArray *searchResults;
    NSArray *searchInitial;
    NSInteger currentPage;
    NSInteger pageContentCount;
    NSInteger totalPages;
    NSMutableArray *responses;
    NSMutableArray *responseCounts;
    NSArray *responseAPList;
    NSString *ap;
    int sIndex;
    NSArray *questions;
    NSMutableArray *questionsMutable;
    BOOL sidebarMenuOpen;
    SWRevealViewController *revealController;
    UITapGestureRecognizer *tap;

    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.disableView.hidden = false;
    sidebarMenuOpen = NO;
    
    revealController = [self revealViewController];
    tap = [revealController tapGestureRecognizer];
    tap.delegate = self;
    surveys = [[NSMutableArray alloc] init];
    //searchResults = [[NSMutableArray alloc] init];
    temp = [[NSMutableArray alloc] init];
    questionsMutable = [[NSMutableArray alloc] init];
    self.spinner.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.spinner];
    [self.spinner startAnimating];
    
    requestUtility *reqUtil = [[requestUtility alloc] init];
    responseCounts = [[NSMutableArray alloc] init];
    responses = [[NSMutableArray alloc] init];
    [reqUtil getData:@"surveys" completion:^(NSDictionary *responseDict){
        for (id survey in responseDict){
            [surveys addObject:survey];
        }

        if(surveys.count == 0){
            [self alertEmptyData];
        }else{
            self.tableView.rowHeight = 150;
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }

    
        self.disableView.hidden = true;
        [self.spinner stopAnimating];
    }];

    self.revealViewController.delegate = self;
    

    

    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }

}
- (void)alertEmptyData{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Empty Data"
                                  message:@"No data available."
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return searchResults.count;
    } else {
        return surveys.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView){
        NSString *responseCount = [NSString stringWithFormat:@"%@", [[searchResults objectAtIndex:indexPath.row] objectAtIndex:2]];
        static NSString *identifier = @"Cell";
        SurveysViewCell *cell = (SurveysViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SurveysViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell contentView].backgroundColor= [UIColor whiteColor];
        cell.questionLabel.text = [[searchResults objectAtIndex:indexPath.row] objectAtIndex:1];
        cell.respLabel.text = responseCount;
        
        if([[[searchResults objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"Yes"]){
            cell.statusImage.image = [UIImage imageNamed:@"Ok-60.png"];
        } else {
            cell.statusImage.image = [UIImage imageNamed:@"Cancel-60.png"];
        }
        tableView.rowHeight = 150;
        return cell;
    }else{
        NSString *responseCount = [NSString stringWithFormat:@"%@", [[surveys objectAtIndex:indexPath.row] objectAtIndex:2]];
        static NSString *identifier = @"Cell";
        SurveysViewCell *cell = (SurveysViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SurveysViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell contentView].backgroundColor= [UIColor whiteColor];
        cell.questionLabel.text = [[surveys objectAtIndex:indexPath.row] objectAtIndex:1];
        cell.respLabel.text = responseCount;
        if([[[surveys objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"Yes"]){
            cell.statusImage.image = [UIImage imageNamed:@"Ok-60.png"];
        } else {
            cell.statusImage.image = [UIImage imageNamed:@"Cancel-60.png"];
        }
    
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.searchDisplayController.active){
    [responses removeAllObjects];
    [responseCounts removeAllObjects];

        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        sIndex = indexPath.row;
        NSString *surveyId = [[searchResults objectAtIndex:indexPath.row] objectAtIndex:0];
        NSLog(@"%@", surveyId);
        requestUtility *reqUtil = [[requestUtility alloc] init];
        ap = [searchResults objectAtIndex:indexPath.row][4];
        if(surveyClicked == NO){
            surveyClicked = YES;
            [reqUtil getData:@"surveydetails" withParams:surveyId completion:^(NSDictionary *responseDict){
                [responses removeAllObjects];
                [responseCounts removeAllObjects];
                for(id resp in responseDict){
                    [responses addObject:resp[0]];
                    [responseCounts addObject:resp[1]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"showSurveyDetail" sender:self];
                });
            }];
        } else {
            [self alertBusy];
            [reqUtil getData:@"surveydetails" withParams:surveyId completion:^(NSDictionary *responseDict){
                [responses removeAllObjects];
                [responseCounts removeAllObjects];
                for(id resp in responseDict){
                    [responses addObject:resp[0]];
                    [responseCounts addObject:resp[1]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"showSurveyDetail" sender:self];
                });
            }];

        }
    }else{
        [responses removeAllObjects];
        [responseCounts removeAllObjects];
        
        indexPath = [self.tableView indexPathForSelectedRow];
        sIndex = indexPath.row;
        NSString *surveyId = [[surveys objectAtIndex:indexPath.row] objectAtIndex:0];
        requestUtility *reqUtil = [[requestUtility alloc] init];
        ap = [surveys objectAtIndex:indexPath.row][4];
        if(surveyClicked == NO){
            surveyClicked = YES;
            [reqUtil getData:@"surveydetails" withParams:surveyId completion:^(NSDictionary *responseDict){
                [responses removeAllObjects];
                [responseCounts removeAllObjects];
                for(id resp in responseDict){
                    [responses addObject:resp[0]];
                    [responseCounts addObject:resp[1]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"showSurveyDetail" sender:self];
                });
            }];
        } else {
            [self alertBusy];
            [reqUtil getData:@"surveydetails" withParams:surveyId completion:^(NSDictionary *responseDict){
                [responses removeAllObjects];
                [responseCounts removeAllObjects];
                for(id resp in responseDict){
                    [responses addObject:resp[0]];
                    [responseCounts addObject:resp[1]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"showSurveyDetail" sender:self];
                });
            }];
            
        }
    }


    
    //NSLog(@"%@", [[surveyPage objectAtIndex:indexPath.row] objectAtIndex:1]);
    
}
- (void)alertBusy{
    if([UIAlertController class]){
        UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Charting..."
                                  message:@"Please Wait."
                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
        [alert addAction:ok];
    
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Charting..."
                                                          message:@"Please Wait."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];

    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showSurveyDetail"]){
        if(self.searchDisplayController.active){
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            //NSLog(@"%ld", (long)indexPath.row);
            SurveyDetailsController *destViewController = [segue.destinationViewController topViewController];
            destViewController.surveyQuestion = [[searchResults objectAtIndex:sIndex] objectAtIndex:1];
            destViewController.responses = responses;
            destViewController.responseCounts = responseCounts;
            responseAPList = [ap componentsSeparatedByString:@","];
            destViewController.responseAPList = responseAPList;
        }else{
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            //NSLog(@"%ld", (long)indexPath.row);
            SurveyDetailsController *destViewController = [segue.destinationViewController topViewController];
            destViewController.surveyQuestion = [[surveys objectAtIndex:sIndex] objectAtIndex:1];
            destViewController.responses = responses;
            destViewController.responseCounts = responseCounts;
            responseAPList = [ap componentsSeparatedByString:@","];
            destViewController.responseAPList = responseAPList;
        }

    }
}



- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF[4] contains[c] %@", searchText];
  
   
    searchResults = [surveys filteredArrayUsingPredicate:resultPredicate];


    
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
        sidebarMenuOpen = NO;
        [self.view removeGestureRecognizer:tap];
    } else {
        [self.view addGestureRecognizer:tap];
        self.view.userInteractionEnabled = NO;
        sidebarMenuOpen = YES;
  
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
        sidebarMenuOpen = NO;
        [self.view removeGestureRecognizer:tap];
    } else {
        
        [self.view addGestureRecognizer:tap];
        self.view.userInteractionEnabled = NO;
        sidebarMenuOpen = YES;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(sidebarMenuOpen == YES){
        return nil;
    } else {
        return indexPath;
    }
}
@end
