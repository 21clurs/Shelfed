//
//  BookCollectionCell.m
//  Shelfed
//
//  Created by Clara Kim on 8/5/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "BookCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@implementation BookCollectionCell

- (void)setBook:(Book *)book{
    _book = book;
    if(book.coverArtThumbnail!=nil){
        [self.coverArtView setImageWithURL: [NSURL URLWithString: book.coverArtThumbnail]];
    }
    else{
        self.coverArtView.image = [UIImage imageNamed:@"NoImageAvailable"];
    }
}

@end
