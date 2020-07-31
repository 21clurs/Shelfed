//
//  FilterByGenreCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/28/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FilterByGenreCell.h"

@implementation FilterByGenreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if(selected == YES)
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        self.accessoryType = UITableViewCellAccessoryNone;
    
}

- (void)setGenre:(NSString *)genre{
    _genre = genre;
    
    if([genre isEqualToString:@"Juvenile Fiction"]){
        self.genreLabel.text = @"Young Adult";
    }
    else{
        self.genreLabel.text = genre;
    }
}

- (Filter *)makeFilterFromCell{
    Filter *filter = [[Filter alloc] initGenreFilterWithGenre:self.genre];
    return filter;
}

@end
