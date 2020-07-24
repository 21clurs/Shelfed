//
//  UploadPhotoViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/23/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "UploadPhotoViewController.h"

@interface UploadPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end

@implementation UploadPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//- (IBAction)didTapPhoto:(id)sender {
-(void)onTap{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"Update your profile photo" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [actionSheet addAction:cancelAction];

    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self.delegate;
        imagePickerController.allowsEditing = YES;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            NSLog(@"Camera 🚫 available display an alert or something");
        }
        [self.delegate presentChildViewController:imagePickerController];
        //[self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    [actionSheet addAction:cameraAction];

    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose from Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self.delegate;
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.delegate presentChildViewController:imagePickerController];
        //[self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    [actionSheet addAction:libraryAction];
    
    [self.delegate presentActions:actionSheet];
    //[self presentViewController:actionSheet animated:YES completion:^{}];
}

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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
