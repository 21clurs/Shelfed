//
//  FilterByPagesCell.h
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FilterByPagesCellDelegate <NSObject>
-(void)filterWithNumPages:(int)pages lessThan:(bool)lessThan;
-(void)filterByPagesCellSelected:(bool)selected lessThan:(bool)lessThan;
@end

@interface FilterByPagesCell : UITableViewCell
@property (weak, nonatomic) id<FilterByPagesCellDelegate> delegate;
@property (nonatomic) bool lessThan;
@property (weak, nonatomic) IBOutlet UILabel *lessGreaterLabel;
@property (weak, nonatomic) IBOutlet UITextField *pageCountField;

@end

NS_ASSUME_NONNULL_END
