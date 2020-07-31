//
//  FilterByPublishCell.h
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FilterByPublishCellDelegate <NSObject>

@end

@interface FilterByPublishCell : UITableViewCell
@property (weak, nonatomic) id<FilterByPublishCellDelegate> delegate;
@property (nonatomic) bool beforeYear;
@property (strong, nonatomic) NSString *yearString;
@property (weak, nonatomic) IBOutlet UITextField *enterYearField;
@property (weak, nonatomic) IBOutlet UILabel *relativeLabel;

- (Filter *)makeFilterFromCell;

@end

NS_ASSUME_NONNULL_END
