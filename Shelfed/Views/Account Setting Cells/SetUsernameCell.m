//
//  SetUsernameCell.m
//  Shelfed
//
//  Created by Clara Kim on 8/11/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "SetUsernameCell.h"
@import Parse;

@implementation SetUsernameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.usernameField.text = PFUser.currentUser.username;
    [self.usernameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveUsernameNotification:) name:@"AccountSettingsNotification" object:nil];
}

-(void)textFieldDidChange :(UITextField *) textField{
    if([textField.text isEqualToString:PFUser.currentUser.username]){
        self.usernameCheckView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
        self.usernameCheckView.tintColor = [UIColor systemGreenColor];
        return;
    }
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:self.usernameField.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error==nil && objects.count<=0){
            self.usernameCheckView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
            self.usernameCheckView.tintColor = [UIColor systemGreenColor];
        }
        else{
            self.usernameCheckView.image = [UIImage systemImageNamed:@"xmark.circle.fill"];
            self.usernameCheckView.tintColor = [UIColor systemRedColor];
        }
    }];
}

-(void) saveUsernameNotification:(NSNotification *) notification{
    if([self.usernameField.text isEqualToString:PFUser.currentUser.username]){
        [self.delegate usernameSaved:YES withMessage:nil];
    }
    else if(self.usernameCheckView.alpha==1){
        PFUser.currentUser.username = self.usernameField.text;
        [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded)
                [self.delegate usernameSaved:succeeded withMessage:nil];
            else{
                [self.delegate usernameSaved:succeeded withMessage:error.localizedDescription];
            }
        }];
    }
    else{
        [self.delegate usernameSaved:NO withMessage:@"Username is taken. Please select a different username."];
    }
}

@end
