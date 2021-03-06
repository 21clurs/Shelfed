//
//  BookCollectionCell.h
//  Shelfed
//
//  Created by Clara Kim on 8/5/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverArtView;
@property (strong, nonatomic) Book *book;
@end

NS_ASSUME_NONNULL_END
