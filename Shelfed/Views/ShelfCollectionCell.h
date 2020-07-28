//
//  ShelfCollectionCell.h
//  Shelfed
//
//  Created by Clara Kim on 7/21/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShelfCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *shelfNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shelfPicView;
@property (strong,nonatomic) NSString *shelfName;
@property (strong, nonatomic) UIVisualEffectView *effectView;

@end

NS_ASSUME_NONNULL_END
