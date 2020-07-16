//
//  ShelfCell.h
//  Shelfed
//
//  Created by Clara Kim on 7/16/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShelfCell : UITableViewCell
@property (strong,nonatomic) NSString *shelfName;
@property (weak, nonatomic) IBOutlet UILabel *shelfNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shelfIconView;
@end

NS_ASSUME_NONNULL_END
