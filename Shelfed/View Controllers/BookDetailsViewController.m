//
//  BookDetailsViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/13/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "BookDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Book.h"
#import "AddRemoveBooksHelper.h"

@interface BookDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverArtView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation BookDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFields];
    // Do any additional setup after loading the view.
}

- (void)setBook:(Book *)book{
    _book = book;
    [self setFields];
    
}

-(void)setFields{
    self.titleLabel.text = self.book.title;
    self.authorLabel.text = self.book.authorsString;
    if(self.book.coverArtThumbnail!=nil){
        [self.coverArtView setImageWithURL:[NSURL URLWithString: self.book.coverArtThumbnail]];
    }
    if ([PFUser.currentUser[@"favoritesArray"] containsObject:self.book.bookID]){
        [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        [self.favoriteButton setTintColor:[UIColor redColor]];
    }
    self.descriptionLabel.text = self.book.bookDescription;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
