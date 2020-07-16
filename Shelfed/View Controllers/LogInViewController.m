//
//  LogInViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/15/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "LogInViewController.h"
#import "Parse/Parse.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didTapLogIn:(id)sender {
    if(![self alertIfEmpty]){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loginUser];
    }
}

- (void)loginUser{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    __weak typeof(self) weakSelf = self;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Logging In" message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [strongSelf presentViewController:alert animated:YES completion:^{}];
        } else {
            NSLog(@"User logged in successfully");
            
            [strongSelf performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
    }];
}

- (BOOL)alertIfEmpty {
    if ([self.usernameField.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Username Required" message:@"A username is required to log in" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{}];
        
        return YES;
    }
    else if([self.passwordField.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password Required" message:@"A password is required to log in" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{}];
        
        return YES;
    }
    return NO;
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
