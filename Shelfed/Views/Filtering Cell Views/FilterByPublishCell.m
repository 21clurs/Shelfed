//
//  FilterByPublishCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FilterByPublishCell.h"
@interface FilterByPublishCell()<UITextFieldDelegate>
@end

@implementation FilterByPublishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.enterYearField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self.enterYearField resignFirstResponder];
    
    if(selected == YES){
        [self.delegate filterByPublishCellSelected:YES before:self.beforeYear];
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        [self.delegate filterByPublishCellSelected:NO before:self.beforeYear];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)setBeforeYear:(bool)beforeYear{
    _beforeYear = beforeYear;
    if(self.beforeYear == YES)
        self.relativeLabel.text = @"Before";
    else
        self.relativeLabel.text = @"After";
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.delegate filterWithYear:self.enterYearField.text before:self.beforeYear];
}

@end
