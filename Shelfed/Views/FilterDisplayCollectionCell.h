//
//  FilterDisplayCollectionCell.h
//  Shelfed
//
//  Created by Clara Kim on 8/6/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FilterDisplayCollectionCellDelegate <NSObject>
-(void)removedFilter;
@end

@interface FilterDisplayCollectionCell : UICollectionViewCell
@property (weak, nonatomic) id<FilterDisplayCollectionCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;
@property (strong, nonatomic) Filter *filter;

@end

NS_ASSUME_NONNULL_END
