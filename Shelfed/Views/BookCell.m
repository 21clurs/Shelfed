//
//  BookCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/13/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "BookCell.h"

@implementation BookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBook:(NSDictionary *)book{
    _book = book;
    
    NSDictionary *volumeInfo = book[@"volumeInfo"];
    self.titleLabel.text = volumeInfo[@"title"];
    
    NSMutableString *authorsString = [NSMutableString string];
    if(volumeInfo[@"authors"]!=nil){
        for( NSString *author in volumeInfo[@"authors"]){
            [authorsString appendString:author];
            [authorsString appendString:@", "];
        }
        self.authorLabel.text = authorsString;
    }
}

@end
