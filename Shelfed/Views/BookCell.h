//
//  BookCell.h
//  Shelfed
//
//  Created by Clara Kim on 7/13/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BookCellDelegate
- (void)didRemove;
@end

@interface BookCell : UITableViewCell

@property (weak, nonatomic)id<BookCellDelegate>delegate;
@property (strong, nonatomic) Book *book;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverArtView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@end

NS_ASSUME_NONNULL_END
