//
//  ViewController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "ViewController.h"
#import "Data.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSURL *loginURL;
    UITextField *activeTextField;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicatorContainer.hidden = true;
    // Do any additional setup after loading the view, typically from a nib.
    self.textFieldUsername.delegate = self;
    self.textFieldPassword.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)buttonLogInClicked:(id)sender {
    [activeTextField resignFirstResponder];
    self.textFieldUsername.hidden = true;
    self.textFieldPassword.hidden = true;
    self.loginButton.hidden = true;
    self.activityIndicatorContainer.hidden = false;
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
                 
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     [Data setUser:username];
                     [Data fillAPArrays];
                     [Data getAgeGenderData];
                     [Data getUserInfo];
                 });

                 [self performSegueWithIdentifier:@"loginSuccess" sender:sender];
             }];
            
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 self.textFieldUsername.hidden = false;
                 self.textFieldPassword.hidden = false;
                 self.loginButton.hidden = false;
                 self.activityIndicatorContainer.hidden = true;
                 [self alertLoginError];
             }];
            
        }
        
        NSLog(@"%@",result);
    }];
    
    [loginDataTask resume];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    // Step 1: Get the size of the keyboard.
    
        CGSize keyboardSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height-10, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        
        // Step 3: Scroll the target text field into view.
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyboardSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y - (keyboardSize.height-15));
            [self.scrollView setContentOffset:scrollPoint animated:YES];
        }

}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"hidden");
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
}
@end
