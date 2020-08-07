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
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
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
    
    __weak __typeof(self) weakSelf = self;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        __strong __typeof(self) strongSelf = weakSelf;
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
            rect.origin.y -= offset;
            rect.size.height += offset;
        }
        else
        {
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
