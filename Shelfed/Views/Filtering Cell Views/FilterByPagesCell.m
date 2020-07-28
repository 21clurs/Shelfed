//
//  FilterByPagesCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FilterByPagesCell.h"

@implementation FilterByPagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

@end
