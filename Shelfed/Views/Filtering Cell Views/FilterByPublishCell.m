//
//  FilterByPublishCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FilterByPublishCell.h"

@implementation FilterByPublishCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBeforeYear:(bool)beforeYear{
    _beforeYear = beforeYear;
    if(self.beforeYear == YES)
        self.relativeLabel.text = @"Before";
    else
        self.relativeLabel.text = @"After";
}

@end
