//
//  UploadCollectionCell.h
//  Shelfed
//
//  Created by Clara Kim on 7/24/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface UploadCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *uploadPhotoView;

@end

NS_ASSUME_NONNULL_END
