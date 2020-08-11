//
//  SetPasswordCell.h
//  Shelfed
//
//  Created by Clara Kim on 8/11/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SetPasswordCellDelegate <NSObject>
-(void)passwordSaved:(bool)success withMessage:(nullable NSString *)message;
@end

@interface SetPasswordCell : UITableViewCell
@property (weak, nonatomic) id<SetPasswordCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *setNewPWField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPWField;
@property (weak, nonatomic) IBOutlet UIImageView *confirmPWCheckView;
@end

NS_ASSUME_NONNULL_END
