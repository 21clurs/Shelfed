//
//  ProfileViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/15/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "LogInViewController.h"
#import "SceneDelegate.h"
#import "UploadPhotoViewController.h"
@import Parse;

@interface ProfileViewController () <UploadPhotoViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *updatePhotoContainerView;

@property (nonatomic) UploadPhotoViewController *uploadPhotoViewController;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = [PFUser.currentUser username];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.updatePhotoContainerView addGestureRecognizer:tapRecognizer];
}

- (void) onTap:(UITapGestureRecognizer *)sender{
    self.uploadPhotoViewController.delegate = self;
    [self.uploadPhotoViewController onTap];
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //UploadPhotoViewController *containerViewController = [storyboard instantiateViewControllerWithIdentifier:@"uploadPhotoStoryboard"];
    //containerViewController.delegate = self;
    //[containerViewController didMoveToParentViewController:self];
    //[containerViewController onTap];
}

- (IBAction)didTapLogOut:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LogInViewController *logInViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
    sceneDelegate.window.rootViewController = logInViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error Logging Out: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - UploadPhotoViewControllerDelegate
- (void)containerViewController:(UploadPhotoViewController *)uploadPhotoViewController presentActionSheet:(UIAlertController *)actionSheet{
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (void)containerViewController:(UploadPhotoViewController *)uploadPhotoViewController presentImagePicker:(UIImagePickerController *)imagePicker{
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"selectPhotoSegue"]){
        if([segue.destinationViewController isKindOfClass:[UploadPhotoViewController class]])
            self.uploadPhotoViewController = [segue destinationViewController];
    }
}


@end
