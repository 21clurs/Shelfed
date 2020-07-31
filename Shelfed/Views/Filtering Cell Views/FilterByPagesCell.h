//
//  FilterByPagesCell.h
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FilterByPagesCellDelegate <NSObject>


@end

@interface FilterByPagesCell : UITableViewCell
@property (weak, nonatomic) id<FilterByPagesCellDelegate> delegate;
@property (nonatomic) bool lessThan;
@property (strong, nonatomic) NSString *pageCountString;
@property (weak, nonatomic) IBOutlet UILabel *lessGreaterLabel;
@property (weak, nonatomic) IBOutlet UITextField *pageCountField;

- (Filter *)makeFilterFromCell;

@end

NS_ASSUME_NONNULL_END
