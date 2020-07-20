//
//  ShelfCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/16/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "ShelfCell.h"

@implementation ShelfCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setShelfName:(NSString *)shelfName{
    _shelfName = shelfName;
    
    self.shelfNameLabel.text = shelfName;
    if([shelfName isEqualToString:@"Read"]){
        [self.shelfIconView setImage:[UIImage systemImageNamed:@"checkmark.seal.fill"]];
    }
    else if([shelfName isEqualToString:@"Reading"]){
        [self.shelfIconView setImage:[UIImage systemImageNamed:@"bookmark.fill"]];
    }
}

@end
