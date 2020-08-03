//
//  BookReusableCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/22/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "BookCellNib.h"
#import "UIImageView+AFNetworking.h"
#import "AddRemoveBooksHelper.h"

@implementation BookCellNib

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void) favoriteButtonSetup{
    self.favoriteButton.delegate = self;
    self.favoriteButton.selectedColor = [UIColor redColor];
    self.favoriteButton.normalColor = [UIColor lightGrayColor];
    
    self.favoriteButton.dotFirstColor = [UIColor yellowColor];
    self.favoriteButton.dotSecondColor = [UIColor blueColor];
}

- (void)setBook:(Book *)book{
    _book = book;
    
    self.titleLabel.text = book.title;
    self.authorLabel.text = book.authorsString;
    if(book.coverArtThumbnail!=nil){
        [self.coverArtView setImageWithURL: [NSURL URLWithString: book.coverArtThumbnail]];
    }
    else{
        self.coverArtView.image = [UIImage imageNamed:@"NoImageAvailable"];
    }
    
    PFRelation *relation = [PFUser.currentUser relationForKey:@"favorites"];
    PFQuery *query = [relation query];
    [query whereKey:@"bookID" equalTo:book.bookID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(object!=nil){
            /*
            [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
            [self.favoriteButton setTintColor:[UIColor redColor]];
             */
            self.favoriteButton.selected = YES;
            self.inFavorites = YES;
        }
        else{
            /*
            [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
            [self.favoriteButton setTintColor:[UIColor blackColor]];
             */
            self.favoriteButton.selected = NO;
            self.inFavorites = NO;
        }
        [self favoriteButtonSetup];
    }];
}
- (void)toggleFavorite{
    __weak typeof(self) weakSelf = self;
    if(self.inFavorites == YES){
        [AddRemoveBooksHelper removeFromFavorites:self.book withCompletion:^(NSError * _Nonnull error) {
            if(!error){
                __strong typeof(self) strongSelf = weakSelf;
                /*
                [strongSelf.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
                [strongSelf.favoriteButton setTintColor:[UIColor blackColor]];
                 */
                self.favoriteButton.selected = NO;
                [strongSelf.delegate didRemove];
                self.inFavorites = NO;
                [self.delegate didRemove];
            }
        }];
    }
    else if(self.inFavorites == NO){
        [AddRemoveBooksHelper addToFavorites:self.book withCompletion:^(NSError * _Nonnull error) {
            if(!error){
                __strong typeof(self) strongSelf = weakSelf;
                /*
                [strongSelf.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
                [strongSelf.favoriteButton setTintColor:[UIColor redColor]];
                */
                self.favoriteButton.selected = YES;
                self.inFavorites = YES;
            }
        }];
    }
}

- (IBAction)didTapFavorite:(id)sender {
    [self toggleFavorite];
}

- (void) didDoubleTap{
    [self toggleFavorite];
}

- (IBAction)didTapMore:(id)sender {
    [self.delegate didTapMore:self.book];
}

@end
