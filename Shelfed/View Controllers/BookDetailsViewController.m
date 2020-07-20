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

@interface BookDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverArtView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

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
}

- (IBAction)didTapFavorite:(id)sender {
    if(PFUser.currentUser[@"favoritesArray"]==nil){
        PFUser.currentUser[@"favoritesArray"] = [[NSMutableArray<Book *> alloc] init];
    }
    NSMutableArray *favorites = PFUser.currentUser[@"favoritesArray"];
    
    if ([favorites containsObject:self.book.bookID]){
        [favorites removeObject:self.book.bookID];
        PFUser.currentUser[@"favoritesArray"] = favorites;
        [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error!=nil){
                NSLog(@"Error removing from user favorites");
            }
            else{
                NSLog(@"Removed");
                [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
                [self.favoriteButton setTintColor:[UIColor blackColor]];
            }
        }];
    }
    else{
        [favorites addObject:self.book.bookID];
        PFUser.currentUser[@"favoritesArray"] = favorites;
        [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error!=nil){
                NSLog(@"Error saving to user favorites");
            }
            else{
                NSLog(@"Saved");
                [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
                [self.favoriteButton setTintColor:[UIColor redColor]];
            }
        }];
    }
    
    NSMutableArray *bookIDs = [[NSMutableArray alloc] init];
    
    PFQuery *booksQuery = [PFQuery queryWithClassName:@"Book"];
    [booksQuery selectKeys: @[@"bookID"]];
    // fetch data asynchronously
    __weak typeof(self) weakSelf = self;
    [booksQuery findObjectsInBackgroundWithBlock:^(NSArray<Book *> * _Nullable books, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (books) {
            for (Book * book in books){
                [bookIDs addObject:book.bookID];
            }
            // Adding the book to Parse if it isn't already there
            if(![bookIDs containsObject:strongSelf.book.bookID]){
                [strongSelf.book saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error!=nil){
                    NSLog(@"Error saving book to Parse");
                }
                else{
                    NSLog(@"Saved to parse");
                }
                }];
            }
        }
        else {
            // handle error
            NSLog(@"Error getting books");
        }
    }];
    
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
