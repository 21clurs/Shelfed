//
//  UploadCollectionViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/24/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "UploadCollectionViewController.h"
#import "UploadPhotoViewController.h"
#import "Parse/Parse.h"

@interface UploadCollectionViewController () <UploadPhotoViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *addUploadContainerView;

@end

@implementation UploadCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.addUploadContainerView addGestureRecognizer:tapRecognizer];
}

-(void)onTap: (UITapGestureRecognizer *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UploadPhotoViewController *containerViewController = [storyboard instantiateViewControllerWithIdentifier:@"uploadPhotoStoryboard"];
    containerViewController.delegate = self;
    [containerViewController didMoveToParentViewController:self];
    [containerViewController onTap];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)didSelectPhoto:(NSData *)imageData{
    /*
    PFUser.currentUser[@"profileImage"] = [PFFileObject fileObjectWithName:@"profile_image.png" data:imageData];
   __weak typeof(self) weakSelf = self;
   [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
       __strong typeof(self) strongSelf = weakSelf;
       if(error != nil){
           NSLog(@"Error updating profile image");
           [strongSelf dismissViewControllerAnimated:YES completion:nil];
       }
       else{
           //[self.tableView reloadData];
           strongSelf.profilePictureView.file = PFUser.currentUser[@"profileImage"];
           [strongSelf.profilePictureView loadInBackground];
           [strongSelf dismissViewControllerAnimated:YES completion:nil];
       }
   }];
     */

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    CGSize size = CGSizeMake(200, 200);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:size];
    
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
    [self didSelectPhoto:imageData];
    
};

#pragma mark - UploadPhotoViewControllerDelegate
- (void)presentActions:(nonnull UIAlertController *)actionSheet {
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)presentChildViewController:(nonnull UIViewController *)childViewController {
    [self presentViewController:childViewController animated:YES completion:nil];
}

@end
