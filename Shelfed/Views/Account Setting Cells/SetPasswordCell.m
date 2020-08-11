//
//  SetPasswordCell.m
//  Shelfed
//
//  Created by Clara Kim on 8/11/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "SetPasswordCell.h"
@import Parse;

@implementation SetPasswordCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.confirmPWField addTarget:self action:@selector(confirmTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(savePasswordNotification:) name:@"AccountSettingsNotification" object:nil];
}

-(void)confirmTextFieldDidChange :(UITextField *) textField{
    if([textField.text isEqualToString:self.setNewPWField.text] && [textField.text length]>0){
        [UIView animateWithDuration:0.1 animations:^{
            self.confirmPWCheckView.alpha = 1;
        }];
    }
    else{
        self.confirmPWCheckView.alpha = 0;
    }
}

-(void) savePasswordNotification:(NSNotification *) notification{
    if(self.confirmPWCheckView.alpha==1){
        PFUser.currentUser.password = self.confirmPWField.text;
        [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded)
                [self.delegate passwordSaved:succeeded withMessage:nil];
            else{
                [self.delegate passwordSaved:succeeded withMessage:error.localizedDescription];
            }
        }];
    }
    else if([self.confirmPWField.text length] == 0 && [self.setNewPWField.text length] == 0){
        [self.delegate passwordSaved:YES withMessage:nil];
    }
    else{
        [self.delegate passwordSaved:NO withMessage:@"Passwords don't match"];
    }
}

@end
