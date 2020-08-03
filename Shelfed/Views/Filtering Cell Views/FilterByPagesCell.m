//
//  FilterByPagesCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FilterByPagesCell.h"
@interface FilterByPagesCell()
@end

@implementation FilterByPagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.pageCountField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)setPageCountString:(NSString *)pageCountString{
    _pageCountString = pageCountString;
    if([pageCountString intValue] == 0)
        self.pageCountField.text = @"";
    else
        self.pageCountField.text = pageCountString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self.pageCountField resignFirstResponder];
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
    if([filter.filterTypeString isEqualToString:@"PagesLess"]){
        self.lessThan = YES;
    }
    else{
        self.lessThan = NO;
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
- (void)textFieldDidChange:(UITextField *) textField{
    self.filter.pages = [textField.text intValue];
}

@end
