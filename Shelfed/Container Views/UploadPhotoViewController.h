//
//  UploadPhotoViewController.h
//  Shelfed
//
//  Created by Clara Kim on 7/23/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UploadPhotoViewController;

@protocol UploadPhotoViewControllerDelegate <NSObject>
- (void)containerViewController:(UploadPhotoViewController *)uploadPhotoViewController presentActionSheet:(UIAlertController *)actionSheet;
- (void)containerViewController:(UploadPhotoViewController *)uploadPhotoViewController presentImagePicker:(UIImagePickerController *)imagePicker;
- (void)removeCurrentPhoto;

@end

@interface UploadPhotoViewController : UIViewController
@property (weak,nonatomic)id<UploadPhotoViewControllerDelegate> delegate;
-(void)onTap;
@end

NS_ASSUME_NONNULL_END
