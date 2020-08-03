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
#import "UploadCollectionViewController.h"

@interface BookDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverArtView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic) bool isFavorite;

@end

@implementation BookDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setBook:(Book *)book{
    _book = book;
    [self checkFavorite];
    
}

-(void)checkFavorite{
    PFRelation *relation = [PFUser.currentUser relationForKey:@"favorites"];
    PFQuery *relationQuery = [relation query];
    [relationQuery whereKey:@"bookID" equalTo:self.book.bookID];
    [relationQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(object!=nil){
            self.isFavorite = YES;
            //self.book = (Book *) object;
        }
        else{
            self.isFavorite = NO;
        }
        [self setupView];
    }];
}

-(void)setupView{
    self.titleLabel.text = self.book.title;
    self.authorLabel.text = self.book.authorsString;
    if(self.book.coverArtThumbnail!=nil){
        [self.coverArtView setImageWithURL:[NSURL URLWithString: self.book.coverArtThumbnail]];
    }
    else{
        self.coverArtView.image = [UIImage imageNamed:@"NoImageAvailable"];
    }
    if (self.isFavorite == YES){
        // [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        [self.favoriteButton setTintColor:[UIColor redColor]];
    }
    else{
        // [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        [self.favoriteButton setTintColor:[UIColor lightGrayColor]];
    }
    self.descriptionLabel.text = self.book.bookDescription;
}

- (IBAction)didTapFavorite:(id)sender {
    __weak typeof(self) weakSelf = self;
    if(self.isFavorite == YES){
        [AddRemoveBooksHelper removeFromFavorites:self.book withCompletion:^(NSError * _Nonnull error) {
            __strong typeof(self) strongSelf = weakSelf;
            if(!error){
                strongSelf.isFavorite = NO;
                [strongSelf setupView];
            }
        }];
    }
    else{
        [AddRemoveBooksHelper addToFavorites:self.book withCompletion:^(NSError * _Nonnull error) {
            __strong typeof(self) strongSelf = weakSelf;
            if(!error){
                strongSelf.isFavorite = YES;
                [strongSelf setupView];
            }
        }];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showUploadsSegue"]){
        UploadCollectionViewController *uploadCollectionViewController = [segue destinationViewController];
        uploadCollectionViewController.book = self.book;
    }
}


@end
