//
//  FilterByPagesCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FilterByPagesCell.h"

@interface FilterByPagesCell() <UITextFieldDelegate>
@end

@implementation FilterByPagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pageCountField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self.pageCountField resignFirstResponder];
    
    if(selected == YES){
        [self.delegate filterByPagesCellSelected:YES lessThan:self.lessThan];
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        [self.delegate filterByPagesCellSelected:NO lessThan:self.lessThan];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}
- (void)setLessThan:(bool)lessThan{
    _lessThan = lessThan;
    if (self.lessThan){
        self.lessGreaterLabel.text = @"<";
    }
    else{
        self.lessGreaterLabel.text = @">";
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.delegate filterWithNumPages:[self.pageCountField.text intValue] lessThan:self.lessThan];
}

@end
