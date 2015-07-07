//
//  ViewController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//
//  Log In Screen for the Dashboard

#import "ViewController.h"
#import "Data.h"
#import "requestUtility.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSURL *loginURL;
    UITextField *activeTextField;
    NSString *cookie;
    NSString *email;
    NSString *password;
    
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
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSuccessfullySignedInBefore"])
    {
        // Don't display username, password textfields and login button
        // First time login
        NSLog(@"FIRST TIME!");
    } else{
        self.textFieldUsername.hidden = true;
        self.textFieldPassword.hidden = true;
        self.loginButton.hidden = true;
        
        self.activityIndicatorContainer.hidden = false;
        [self reLogIn];
    }
    self.loginButton.layer.cornerRadius = 4.0f;
    [self.loginButton setClipsToBounds:YES];
    
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

// Alert for Login Error Due to wrong credentials.
- (void)alertLoginError{
    if ([UIAlertController class]) {
        // use UIAlertController
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Login Error"
                                      message:@"Check your username/password."
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
        
    } else {
        // use UIAlertView
        // use UIAlertView
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                          message:@"Check your username/password."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }

}

// Alert for Login Error Due to network issues
- (void)alertLoginNetworkError{
    
    if ([UIAlertController class]) {
        // use UIAlertController
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Login Error"
                                      message:@"Check your network connection."
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
        
    } else {
        // use UIAlertView
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                          message:@"Check your network connection."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }

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
    password = [NSString stringWithString:[self.textFieldPassword text]];
    //loginURL = [NSURL URLWithString:@"http://dev.wifination.ph:3000/login_app/"];
    NSLog(@"%@", [self.textFieldPassword text]);
    
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil logIn:username password:password completion:^(NSString *status){
        NSLog(@"STATUS OF LOGIN: %@",status);
        if([status isEqualToString:@"OK"]){
            [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
            NSString *devToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
            devToken = [devToken stringByReplacingOccurrencesOfString:@" " withString:@""];
            devToken = [devToken stringByReplacingOccurrencesOfString:@">" withString:@""];
            devToken = [devToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [reqUtil postDeviceToken:devToken forDevice:[[NSUserDefaults standardUserDefaults] objectForKey:@"machine"] withTag:@"iOS"];
                NSLog(@"DEVICE TOKEN: %@", devToken);
                [Data setUser:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]];
                [Data fillAPArrays];
                [Data getAgeGenderData];
                [Data getUserInfo];
                [Data getDateToday];
            });
            [self performSegueWithIdentifier:@"loginSuccess" sender:self];
        }else if([status isEqualToString:@"error"]){
            [self alertLoginError];
            self.textFieldUsername.hidden = false;
            self.textFieldPassword.hidden = false;
            self.loginButton.hidden = false;
            
            self.activityIndicatorContainer.hidden = true;
        } else {
            [self alertLoginNetworkError];
            self.textFieldUsername.hidden = false;
            self.textFieldPassword.hidden = false;
            self.loginButton.hidden = false;
            
            self.activityIndicatorContainer.hidden = true;
        }

    }];
    
    
    


}

// called when user has successfull logged in before
- (void)reLogIn{
    loginURL = [NSURL URLWithString:@"https://wifination.ph/login_app/"];
    NSString *boundary = @"WebKitFormBoundary";
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"username"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[NSUserDefaults standardUserDefaults] stringForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"password"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[NSUserDefaults standardUserDefaults] stringForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
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
                     [Data setUser:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]];
                     [Data fillAPArrays];
                     [Data getAgeGenderData];
                     [Data getUserInfo];
                     [Data getDateToday];
                 });
                 
                 [self performSegueWithIdentifier:@"loginSuccess" sender:self];
             }];
            
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 self.textFieldUsername.hidden = false;
                 self.textFieldPassword.hidden = false;
                 self.loginButton.hidden = false;
                 self.activityIndicatorContainer.hidden = true;
                 [self alertLoginNetworkError];
             }];
            
        }
        
        NSLog(@"%@",result);
    }];
    
    [loginDataTask resume];
        
}

// Methods for moving the input fields on the log in screen so as not to be blocked by the keyboard
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
