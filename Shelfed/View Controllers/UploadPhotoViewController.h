//
//  UploadPhotoViewController.h
//  Shelfed
//
//  Created by Clara Kim on 7/23/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol UploadPhotoViewControllerDelegate <NSObject>

-(void)presentActions:(UIAlertController *)actionSheet;
-(void)presentChildViewController:(UIViewController *)childViewController;
@end

@interface UploadPhotoViewController : UIViewController
@property (weak,nonatomic)id<UploadPhotoViewControllerDelegate> delegate;
-(void)onTap;
@end

NS_ASSUME_NONNULL_END
