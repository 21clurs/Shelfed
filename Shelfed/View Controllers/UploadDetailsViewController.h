//
//  UploadDetailsViewController.h
//  Shelfed
//
//  Created by Clara Kim on 8/3/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Upload.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UploadDetailsViewControllerDelegate <NSObject>
-(void)didDeleteUpload;
@end

@interface UploadDetailsViewController : UIViewController
@property (strong, nonatomic) Upload *upload;
@property (strong, nonatomic) UIImage *uploadImage;
@property (weak, nonatomic) id<UploadDetailsViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
