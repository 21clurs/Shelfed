//
//  FilterByPublishCell.h
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FilterByPublishCellDelegate <NSObject>
- (void)filterWithYear:(NSString *)yearString before:(bool)before;
- (void)filterByPublishCellSelected:(bool)selected before:(bool)before;
@end

@interface FilterByPublishCell : UITableViewCell
@property (weak, nonatomic) id<FilterByPublishCellDelegate> delegate;
@property (nonatomic) bool beforeYear;
@property (weak, nonatomic) IBOutlet UITextField *enterYearField;
@property (weak, nonatomic) IBOutlet UILabel *relativeLabel;

@end

NS_ASSUME_NONNULL_END
