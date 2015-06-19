//
//  TestimonialsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/15/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "TestimonialsController.h"
#import "SWRevealViewController.h"
#import "requestUtility.h"
#import "MessageCell.h"
#import "SWTableViewCell.h"

@interface TestimonialsController ()

@end

@implementation TestimonialsController
{
    NSMutableArray *messages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    messages = [[NSMutableArray alloc] init];
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil GETRequestSender:@"getMessages" completion:^(NSDictionary *responseDict){
        //NSLog(@"Messages: %@", responseDict);
        for (id message in responseDict){
            [messages addObject:message];
        }
        NSLog(@"%@", messages);
        self.tableView.rowHeight = 100;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messages.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:1]];
    NSString *estab = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:0]];
    NSString *time = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:3]];
    NSString *testimonial = [NSString stringWithFormat:@"%@", [[messages objectAtIndex:indexPath.row] objectAtIndex:4]];
    static NSString *identifier = @"Cell";
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    //SWTableViewCell
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                icon:[UIImage imageNamed:@"Twitter-80.png"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                icon:[UIImage imageNamed:@"Facebook-80.png"]];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;
    cell.nameLabel.text = name;
    cell.estabLabel.text = estab;
    cell.timeLabel.text = time;
    cell.testimonialLabel.text = testimonial;
    return cell;
    
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
