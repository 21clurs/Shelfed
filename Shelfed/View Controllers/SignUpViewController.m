//
//  SignUpViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/15/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)didTapSignUp:(id)sender {
    [self alertIfEmpty];
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.usernameField.text;
    
    if([self.passwordConfirmField.text isEqualToString:self.passwordField.text]){
        newUser.password = self.passwordField.text;
        
        __weak typeof(self) weakSelf = self;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            __strong typeof(self) strongSelf = weakSelf;
            if (error != nil) {
                //NSLog(@"Error: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Signing Up" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
                [alert addAction:okAction];
                [strongSelf presentViewController:alert animated:YES completion:^{}];
            } else {
                //NSLog(@"User registered successfully");
                newUser[@"userShelves"] = [[NSMutableArray alloc] initWithObjects:@"Read", @"Reading",nil];
                [newUser saveInBackground];
                [weakSelf performSegueWithIdentifier:@"signedUpSegue" sender:nil];
            }
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        }];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Passwords do not match" message:@"Please confirm that your passwords match" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        
        __weak typeof(self) weakSelf = self;
        [self presentViewController:alert animated:YES completion:^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    }
}

- (void)alertIfEmpty {
    
    if (self.usernameField.text.length > 0 && self.passwordField.text.length > 0){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self registerUser];
    }
    else{
        UIAlertController *alert;
        if (self.usernameField.text.length == 0){
            alert = [UIAlertController alertControllerWithTitle:@"Username Required" message:@"A username is required to sign up" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
        }
        else if(self.passwordField.text.length == 0){
            alert = [UIAlertController alertControllerWithTitle:@"Password Required" message:@"A password is required to sign up" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
        }
        [self presentViewController:alert animated:YES completion:^{}];
    }
}

- (IBAction)didTapBackToLogIn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)didTapOut:(id)sender {
    [self.view endEditing:YES];
}

-(void)keyboardWillShow{
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}

-(void)keyboardWillHide{
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    int offset = 40;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        if (movedUp)
        {
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            rect.origin.y -= offset;
            rect.size.height += offset;
        }
        else
        {
            // revert back to the normal state.
            rect.origin.y += offset;
            rect.size.height -= offset;
        }
        self.view.frame = rect;
    }];
}


- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
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
