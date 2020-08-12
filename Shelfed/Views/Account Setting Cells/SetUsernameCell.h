//
//  SetUsernameCell.h
//  Shelfed
//
//  Created by Clara Kim on 8/11/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SetUsernameCellDelegate <NSObject>
-(void)usernameSaved:(bool)success withMessage:(nullable NSString *)message;
@end

@interface SetUsernameCell : UITableViewCell
@property (weak, nonatomic) id<SetUsernameCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UIImageView *usernameCheckView;
@end

NS_ASSUME_NONNULL_END
