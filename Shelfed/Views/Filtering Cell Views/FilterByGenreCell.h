//
//  FilterByGenreCell.h
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterByGenreCell : UITableViewCell
@property (strong,nonatomic) NSString *genre;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;

@end

NS_ASSUME_NONNULL_END
