//
//  ViewController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSURL *loginURL;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonLogInClicked:(id)sender {
    username = [NSString stringWithString:[self.textFieldUsername text]];
    loginURL = [NSURL URLWithString:@"http://dev.wifination.ph:3000/login_app/"];
    NSLog(@"%@", [self.textFieldPassword text]);
    NSString *boundary = @"WebKitFormBoundary";
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"username"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [self.textFieldUsername text]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"password"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [self.textFieldPassword text]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]};
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: loginURL];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = body;

    
    NSURLSessionDataTask *loginDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if([result[@"status"] isEqualToString:@"OK"]){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 [self performSegueWithIdentifier:@"loginSuccess" sender:sender];
             }];
            
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 [self alertLoginError];
             }];
            
        }
         
        NSLog(@"%@",result);
    }];
    
    [loginDataTask resume];
    

    
}
- (void)alertLoginError{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Login Error"
                                  message:@"Check your username/password"
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

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
