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

@interface SurveysController () <UISearchBarDelegate, UISearchResultsUpdating>
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults;

@end
@implementation SurveysController
{
    NSMutableArray *surveys;
    NSMutableArray *searchResults;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil GETRequestSender:@"getSurveys" completion:^(NSDictionary* responseDict){
        //NSLog(@"SURVEYS: %@", responseDict);
        for (id survey in responseDict){
            [surveys addObject:survey];
        }
        NSLog(@"%@", surveys[0][1]);
        self.tableView.rowHeight = 150;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }];
    
    /********************Search Controller Code*********************/
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SurveysSearchResultsNavController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController: searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    NSMutableArray *scopeButtonTitles = [[NSMutableArray alloc] init];
    [scopeButtonTitles addObject:NSLocalizedString(@"All", @"Search display controller All button.")];
    
    
    self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles;
    self.searchController.searchBar.delegate = self;
    
    self.definesPresentationContext = YES;
    
     /********************Search Controller Code*********************/
    surveys = [[NSMutableArray alloc] init];
  
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[surveys count]];
    

    
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
/*
- (void)updateFilteredContentForProductName:(NSString *)productName type:(NSString *)typeName {
    
    // Update the filtered array based on the search text and scope.
    if ((productName == nil) || [productName length] == 0) {
        // If there is no search string and the scope is "All".
        if (typeName == nil) {
            self.searchResults = [self.products mutableCopy];
        } else {
            // If there is no search string and the scope is chosen.
            NSMutableArray *searchResults = [[NSMutableArray alloc] init];
            for (Product *product in self.products) {
                if ([product.type isEqualToString:typeName]) {
                    [searchResults addObject:product];
                }
            }
            self.searchResults = searchResults;
        }
        return;
    }
    
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
     //Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
    for (Product *product in self.products) {
        if ((typeName == nil) || [product.type isEqualToString:typeName]) {
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, product.name.length);
            NSRange foundRange = [product.name rangeOfString:productName options:searchOptions range:productNameRange];
            if (foundRange.length > 0) {
                [self.searchResults addObject:product];
            }
        }
    }
}
*/


@end
