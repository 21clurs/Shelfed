//
//  BookCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/13/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "BookCell.h"
#import "UIImageView+AFNetworking.h"
#import "AddRemoveBooksHelper.h"

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
    if([PFUser.currentUser[@"favoritesArray"] containsObject:book.bookID]){
        [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        [self.favoriteButton setTintColor:[UIColor redColor]];
    }
    else{
        [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        [self.favoriteButton setTintColor:[UIColor blackColor]];
    }
}

- (IBAction)didTapFavorite:(id)sender {
    NSMutableArray<NSString *> *favorites = PFUser.currentUser[@"favoritesArray"];
    if(PFUser.currentUser[@"favoritesArray"]==nil){
        favorites = [[NSMutableArray<NSString *> alloc] init];
    }
    
    if ([favorites containsObject:self.book.bookID]){
        [AddRemoveBooksHelper removeFromFavorites:self.book withCompletion:^(NSError * _Nonnull error) {
            if(!error){
                [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
                [self.favoriteButton setTintColor:[UIColor blackColor]];
                [self.delegate didRemove];
            }
        }];
    }
    else{
        [AddRemoveBooksHelper addToFavorites:self.book withCompletion:^(NSError * _Nonnull error) {
            if(!error){
                [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
                [self.favoriteButton setTintColor:[UIColor redColor]];
            }
        }];
    }
}

@end
