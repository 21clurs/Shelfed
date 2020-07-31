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
- (void)setPageCountString:(NSString *)pageCountString{
    _pageCountString = pageCountString;
    self.pageCountField.text = pageCountString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self.pageCountField resignFirstResponder];
    
    if(selected == YES){
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
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
    //[self setSelected:YES animated:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (Filter *)makeFilterFromCell{
    Filter *filter = [[Filter alloc] initLengthFilterWithPages:self.pageCountField.text andLessThan:self.lessThan];
    return filter;
}

@end
