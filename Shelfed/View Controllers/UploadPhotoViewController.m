//
//  UploadPhotoViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/23/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import "UploadImageHelper.h"
@import Parse;

@interface UploadPhotoViewController () < UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *updateIconView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoView;

@end

@implementation UploadPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(PFUser.currentUser[@"profileImage"]){
        self.profilePhotoView.file = PFUser.currentUser[@"profileImage"];
    }
    else{
        self.profilePhotoView.image = [UIImage imageNamed:@"default_profile_image"];
    }
    [self.profilePhotoView loadInBackground];
}

-(void)onTap{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"Update your profile photo" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [actionSheet addAction:cancelAction];

    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    [actionSheet addAction:cameraAction];

    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose from Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self openGallery];
    }];
    [actionSheet addAction:libraryAction];
    
    [self.delegate containerViewController:self presentActionSheet:actionSheet];
}

-(void) openGallery{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.delegate containerViewController:self presentImagePicker:imagePickerController];
}

-(void) openCamera{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available");
    }
    [self.delegate containerViewController:self presentImagePicker:imagePickerController];
}

- (void)didSelectPhoto:(NSData *)imageData{
    PFUser.currentUser[@"profileImage"] = [PFFileObject fileObjectWithName:@"profile_image.png" data:imageData];
   __weak typeof(self) weakSelf = self;
   [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
       __strong typeof(self) strongSelf = weakSelf;
       if(error != nil){
           NSLog(@"Error updating profile image");
           [strongSelf dismissViewControllerAnimated:YES completion:nil];
       }
       else{
           strongSelf.profilePhotoView.file = PFUser.currentUser[@"profileImage"];
           [strongSelf.profilePhotoView loadInBackground];
           [strongSelf dismissViewControllerAnimated:YES completion:nil];
       }
   }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [UploadImageHelper resizeImage:editedImage withSize:CGSizeMake(200,200)];
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
    
    [self didSelectPhoto:imageData];
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
