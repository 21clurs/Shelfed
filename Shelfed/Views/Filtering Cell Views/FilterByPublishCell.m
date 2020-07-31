//
//  FilterByPublishCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FilterByPublishCell.h"
@interface FilterByPublishCell()
@end

@implementation FilterByPublishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.enterYearField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)setYearString:(NSString *)yearString{
    _yearString = yearString;
    self.enterYearField.text = yearString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self.enterYearField resignFirstResponder];
    self.filter.selected = selected;
    if(selected == YES){
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}
- (void)setFilter:(Filter *)filter{
    _filter = filter;
    if([filter.filterTypeString isEqualToString:@"PublishedBefore"]){
        self.beforeYear = YES;
    }
    else{
        self.beforeYear = NO;
    }
}
- (void)setBeforeYear:(bool)beforeYear{
    _beforeYear = beforeYear;
    if(self.beforeYear == YES)
        self.relativeLabel.text = @"Before";
    else
        self.relativeLabel.text = @"After";
}
- (void)textFieldDidChange:(UITextField *) textField{
    self.filter.year = [textField.text intValue];
}

@end
