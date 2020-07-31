//
//  FilterByGenreCell.h
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FilterByGenreCellDelegate <NSObject>

@end

@interface FilterByGenreCell : UITableViewCell
@property (weak, nonatomic)id<FilterByGenreCellDelegate> delegate;
@property (strong,nonatomic) NSString *genre;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;

- (Filter *)makeFilterFromCell;

@end

NS_ASSUME_NONNULL_END
