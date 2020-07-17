//
//  BookCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/13/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "BookCell.h"
#import "UIImageView+AFNetworking.h"

@implementation BookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBook:(Book *)book{
    _book = book;
    
    self.titleLabel.text = book.title;
    self.authorLabel.text = book.authorsString;
    if(book.coverArtThumbnail!=nil){
        [self.coverArtView setImageWithURL: [NSURL URLWithString: book.coverArtThumbnail]];
    }
    /*
    NSDictionary *volumeInfo = book[@"volumeInfo"];
    self.titleLabel.text = volumeInfo[@"title"];
    
    if(volumeInfo[@"authors"]!=nil){
        NSString *authorsString = [volumeInfo[@"authors"] componentsJoinedByString:@", "];
        self.authorLabel.text = authorsString;
    }
    else{
        self.authorLabel.text = @"";
    }
    
    if([volumeInfo valueForKeyPath:@"imageLinks.smallThumbnail"]!=nil){
        NSMutableString *imageURLString = [NSMutableString stringWithString:[volumeInfo valueForKeyPath:@"imageLinks.smallThumbnail"]];
        [imageURLString insertString:@"s" atIndex:4];
        [self.coverArtView setImageWithURL:[NSURL URLWithString:imageURLString]];
    }
     */
}

@end
